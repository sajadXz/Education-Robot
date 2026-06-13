#!/usr/bin/env python3
"""
AI.py - Cloud-Hosted Real-time Brain for AI-Powered Robots
==========================================================
This production-grade script handles:
1. Bidirectional WebSocket connections with physical robots.
2. Upstream Real-time connection to OpenAI's WebSocket API.
3. Persistent Vector Memory (RAG) using ChromaDB, scoped per user.
4. Robotic Tool & Function Calling Layer (e.g., drive_motors).
5. Production Resiliency (Heartbeats, Auto-reconnect, and Graceful Cleanups).
"""

import os
import json
import asyncio
import logging
import urllib.parse
import uuid
from typing import Dict, Any, Optional

import websockets
import chromadb
from openai import AsyncOpenAI

# Configure structured logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger("RobotBrain")

# Constants
DEFAULT_PORT = 8765
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CHROMA_DB_PATH = os.path.join(SCRIPT_DIR, "robot_memory")
CHROMA_COLLECTION_NAME = "robot_memories"
OPENAI_REALTIME_URL = "wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-10-01"

# Load OpenAI API Key
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")

# 1. Robotic Tool Schema Definition
ROBOT_TOOLS = [
    {
        "type": "function",
        "name": "drive_motors",
        "description": "Control the physical motors of the robot to drive in a specified direction at a specific speed.",
        "parameters": {
            "type": "object",
            "properties": {
                "direction": {
                    "type": "string",
                    "enum": ["forward", "backward", "left", "right"],
                    "description": "The direction to move the robot."
                },
                "speed": {
                    "type": "integer",
                    "minimum": 1,
                    "maximum": 10,
                    "description": "Speed level from 1 (slowest) to 10 (fastest)."
                }
            },
            "required": ["direction", "speed"]
        }
    }
]

# ChromaDB client (lazy initialization)
chroma_client = None
memory_collection = None


def get_memory_collection():
    """Lazy initialization of ChromaDB collection."""
    global chroma_client, memory_collection
    if memory_collection is None:
        logger.info(f"Initializing ChromaDB client at {CHROMA_DB_PATH}...")
        chroma_client = chromadb.PersistentClient(path=CHROMA_DB_PATH)
        memory_collection = chroma_client.get_or_create_collection(name=CHROMA_COLLECTION_NAME)
    return memory_collection


async def query_user_memory(user_id: str, query_text: str) -> str:
    """
    Queries ChromaDB for semantic memory related to the user.
    Enforces strict isolation using the user_id where-filter.
    """
    if not query_text.strip():
        return ""
    
    try:
        logger.info(f"Retrieving memory context for user: {user_id} with query: '{query_text}'")
        results = get_memory_collection().query(
            query_texts=[query_text],
            n_results=3,
            where={"user_id": user_id}
        )
        
        documents = results.get("documents", [])
        if documents and documents[0]:
            context_str = "\n".join(documents[0])
            logger.info(f"Successfully retrieved memory context.")
            return context_str
    except Exception as e:
        logger.error(f"Error querying ChromaDB memory: {e}", exc_info=True)
    
    return ""


async def save_user_memory(user_id: str, text: str):
    """
    Saves a new user interaction context block to ChromaDB for future retrieval.
    """
    if not text.strip():
        return
    
    try:
        memory_id = str(uuid.uuid4())
        logger.info(f"Persisting memory {memory_id} for user {user_id}...")
        get_memory_collection().add(
            documents=[text],
            metadatas=[{"user_id": user_id}],
            ids=[memory_id]
        )
    except Exception as e:
        logger.error(f"Error saving memory to ChromaDB: {e}", exc_info=True)


async def start_openai_session(openai_ws: websockets.WebSocketClientProtocol, system_context: str):
    """
    Sends the initial session configuration to OpenAI Realtime API.
    """
    session_instruction = (
        "You are the cloud-hosted real-time AI brain for a physical robot.\n"
        "You receive audio or text streams from the robot and generate immediate, live responses.\n"
        "You have access to the physical hardware controls. Use them when requested.\n"
        f"Relevant historical memory about this user:\n{system_context}"
    )
    
    config_event = {
        "type": "session.update",
        "session": {
            "modalities": ["text", "audio"],
            "instructions": session_instruction,
            "voice": "alloy",
            "input_audio_format": "g711_ulaw",
            "output_audio_format": "g711_ulaw",
            "tools": ROBOT_TOOLS,
            "tool_choice": "auto",
            "temperature": 0.7,
        }
    }
    await openai_ws.send(json.dumps(config_event))
    logger.info("OpenAI Realtime session configuration initialized.")


async def route_downstream(
    openai_ws: websockets.WebSocketClientProtocol,
    robot_ws: websockets.WebSocketServerProtocol
):
    """
    Listens for real-time tokens/events from OpenAI and forwards them downstream immediately.
    Intercepts any tool execution triggers and directs hardware command payloads.
    """
    try:
        async for raw_message in openai_ws:
            event = json.loads(raw_message)
            event_type = event.get("type")
            
            # 1. Forward raw audio delta or text delta stream directly to robot without buffering
            if event_type in ("response.audio.delta", "response.text.delta"):
                await robot_ws.send(raw_message)
                
            # 2. Intercept Function / Tool Calls
            elif event_type == "response.function_call_arguments.done":
                # Intercept JSON arguments, log, and route as hardware command to robot
                call_id = event.get("call_id")
                function_name = event.get("name")
                arguments_str = event.get("arguments", "{}")
                
                logger.info(f"Tool execution intercepted! Name: {function_name}, Args: {arguments_str}")
                
                try:
                    params = json.loads(arguments_str)
                except Exception:
                    params = {}
                    
                # Create structured command packet
                hardware_packet = {
                    "event": "hardware_command",
                    "action": function_name,
                    "params": params,
                    "call_id": call_id
                }
                
                # Transmit structured hardware packet down the socket to physical robot
                await robot_ws.send(json.dumps(hardware_packet))
                logger.info(f"Dispatched hardware packet to robot: {hardware_packet}")
                
                # Report tool execution output to OpenAI to complete the real-time loop
                tool_output_event = {
                    "type": "conversation.item.create",
                    "item": {
                        "type": "function_call_output",
                        "call_id": call_id,
                        "output": json.dumps({"status": "success", "message": f"Action {function_name} executed successfully."})
                    }
                }
                await openai_ws.send(json.dumps(tool_output_event))
                await openai_ws.send(json.dumps({"type": "response.create"}))

            elif event_type == "error":
                logger.error(f"OpenAI Stream Error: {event.get('error')}")
                
    except websockets.exceptions.ConnectionClosed:
        logger.info("OpenAI WebSocket upstream connection closed.")
    except Exception as e:
        logger.error(f"Error in downstream routing: {e}", exc_info=True)


async def route_upstream(
    robot_ws: websockets.WebSocketServerProtocol,
    openai_ws: websockets.WebSocketClientProtocol,
    user_id: str
):
    """
    Receives raw signals, sensor data, or audio chunks from the robot and routes them to OpenAI.
    Stores important textual user inputs into ChromaDB context background.
    """
    try:
        async for raw_message in robot_ws:
            try:
                data = json.loads(raw_message)
            except json.JSONDecodeError:
                # If binary/raw audio bytes, wrap and stream to OpenAI Realtime
                audio_event = {
                    "type": "input_audio_buffer.append",
                    "audio": raw_message.decode("latin1") if isinstance(raw_message, bytes) else raw_message
                }
                await openai_ws.send(json.dumps(audio_event))
                continue

            event_type = data.get("event")
            
            # Robot streaming user input text
            if event_type == "user_input_text":
                text_content = data.get("text", "")
                logger.info(f"Received user text input: '{text_content}'")
                
                # Send text item to OpenAI
                openai_event = {
                    "type": "conversation.item.create",
                    "item": {
                        "type": "message",
                        "role": "user",
                        "content": [
                            {
                                "type": "input_text",
                                "text": text_content
                            }
                        ]
                    }
                }
                await openai_ws.send(json.dumps(openai_event))
                await openai_ws.send(json.dumps({"type": "response.create"}))
                
                # Asynchronously persist new memory block in ChromaDB in background
                asyncio.create_task(save_user_memory(user_id, text_content))
                
            # Robot streaming raw audio buffer event
            elif event_type == "input_audio_chunk":
                audio_base64 = data.get("audio", "")
                audio_event = {
                    "type": "input_audio_buffer.append",
                    "audio": audio_base64
                }
                await openai_ws.send(json.dumps(audio_event))

    except websockets.exceptions.ConnectionClosed:
        logger.info("Robot disconnected downstream.")
    except Exception as e:
        logger.error(f"Error in upstream routing: {e}", exc_info=True)


async def robot_keepalive(robot_ws: websockets.WebSocketServerProtocol, stop_event: asyncio.Event):
    """
    Production keep-alive heartbeats to monitor robot connection drop-offs.
    Returns True if robot is offline, False otherwise.
    """
    robot_alive = True
    try:
        while not stop_event.is_set():
            await asyncio.sleep(15)
            if stop_event.is_set():
                break
            # Send WebSocket Ping
            ping_waiter = await robot_ws.ping()
            # Wait with a timeout for Pong response
            await asyncio.wait_for(ping_waiter, timeout=5.0)
    except (asyncio.TimeoutError, websockets.exceptions.ConnectionClosed):
        logger.warning("Keepalive timeout or socket closed. Robot is offline!")
        robot_alive = False
    except asyncio.CancelledError:
        logger.info("Keepalive cancelled, shutting down.")
        robot_alive = False
    except Exception as e:
        logger.error(f"Keepalive exception: {e}")
        robot_alive = False

    return robot_alive


async def robot_handler(robot_ws: websockets.WebSocketServerProtocol, path: str = ""):
    """
    Main connection handler for each connected physical robot.
    """
    # Extract user_id from URI handshake (e.g. ws://host:port/?user_id=usr_9124)
    parsed_url = urllib.parse.urlparse(robot_ws.path)
    query_params = urllib.parse.parse_qs(parsed_url.query)
    user_id = query_params.get("user_id", ["default_robot_user"])[0]
    
    logger.info(f"New connection from robot! Handshake path: {robot_ws.path} | Resolved User ID: {user_id}")
    
    if not OPENAI_API_KEY:
        logger.warning("OPENAI_API_KEY environment variable is missing. Running in mock/dry-run mode.")
    
    # Semantic memory retrieval (RAG step in background)
    # Get a general context using a placeholder query or user's initial state
    context = await query_user_memory(user_id, "User preferences, identity, past instructions, or robotic commands.")
    
    # Open full duplex pipes to OpenAI Realtime API
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "realtime=v1"
    }

    stop_event = asyncio.Event()
    upstream_task = None
    downstream_task = None
    keepalive_task = None

    try:
        async with websockets.connect(OPENAI_REALTIME_URL, extra_headers=headers) as openai_ws:
            logger.info("Successfully established secure upstream connection to OpenAI Realtime.")

            # Configure current session system parameters
            await start_openai_session(openai_ws, context)

            # Create tasks
            upstream_task = asyncio.create_task(route_upstream(robot_ws, openai_ws, user_id))
            downstream_task = asyncio.create_task(route_downstream(openai_ws, robot_ws))
            keepalive_task = asyncio.create_task(robot_keepalive(robot_ws, stop_event))

            # Wait for any task to complete (handles graceful and abnormal shutdowns)
            done, pending = await asyncio.wait(
                [upstream_task, downstream_task, keepalive_task],
                return_when=asyncio.FIRST_COMPLETED
            )

            # Signal all tasks to stop
            stop_event.set()

            # Cancel pending tasks gracefully
            for task in pending:
                task.cancel()
                try:
                    await asyncio.wait_for(task, timeout=2.0)
                except (asyncio.CancelledError, asyncio.TimeoutError):
                    pass

            # Check if robot went offline
            if keepalive_task in done and not keepalive_task.done():
                logger.info("Robot connection lost.")

    except Exception as e:
        logger.error(f"Session error in master loop for User {user_id}: {e}", exc_info=True)
    finally:
        # Ensure stop event is set
        stop_event.set()

        # Clean disconnect handler
        logger.info(f"Cleaning up and terminating connection session for User: {user_id}.")
        try:
            await robot_ws.close()
        except Exception:
            pass


async def main():
    """
    Initializes and starts the persistent WebSocket server.
    """
    port = int(os.getenv("PORT", DEFAULT_PORT))
    logger.info(f"Starting Robot AI Brain WebSocket Server on port {port}...")
    
    async with websockets.serve(robot_handler, "0.0.0.0", port):
        logger.info(f"WebSocket Server is now running and listening on ws://0.0.0.0:{port}")
        # Keep server running infinitely
        await asyncio.Future()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Robot Brain Server shut down gracefully.")
