---
name: ai--cognitive-logic
description: Guides the agent in implementing LLM integrations, prompt engineering, and agentic workflows within applications.
---

# AI & Cognitive Logic

## Instructions
When building AI features, generating prompts, or orchestrating LLMs:
1.  **Prompt Engineering:** Use clear system instructions, assign roles, and provide few-shot examples to guide the LLM's behavior.
2.  **Structured Output:** Always enforce strict output formats (like JSON) using tools like Pydantic, function calling, or JSON mode to ensure the application can parse the AI's response.
3.  **Context Window Management:** Implement logic to truncate, summarize, or paginate conversation history to avoid exceeding token limits.
4.  **Temperature Control:** Set low temperatures (0.0 - 0.2) for analytical, code, or factual tasks, and higher temperatures (0.7+) for creative generation.

## Examples

**User Query:** "Write a prompt to extract user details from an email."

**Agent Execution:**
* **Prompt Design:** "You are a data extraction assistant. Extract the name, phone number, and intent from the following email. Return ONLY a valid JSON object matching this schema: { 'name': string, 'phone': string, 'intent': string }."
* **Implementation:** Recommend using OpenAI's Function Calling or generic JSON mode to guarantee the structure.
description: Brief description of what this Skill does and when to use it
---

# Ai  Cognitive Logic

## Instructions
Provide clear, step-by-step guidance for Blackbox agents.

## Examples
Show concrete examples of using this Skill.
