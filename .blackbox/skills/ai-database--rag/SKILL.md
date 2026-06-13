---
name: ai-database--rag
description: Empowers the agent to design and manage vector databases and Retrieval-Augmented Generation (RAG) pipelines.
---

# AI Database & RAG

## Instructions
When working with vector search, embeddings, or RAG architectures:
1.  **Embedding Strategy:** Select an appropriate embedding model based on the domain (e.g., text-embedding-3-small for general text, specialized models for code).
2.  **Chunking Logic:** Implement semantic text splitting. Do not cut off context mid-sentence. Include overlap between chunks to preserve relational context.
3.  **Vector Indexing:** Use the correct vector database (Pinecone, Qdrant, pgvector) and apply metadata tags to chunks to allow for hybrid search (vector similarity + metadata filtering).
4.  **Retrieval Optimization:** Implement a re-ranking step (Cross-Encoder) after initial retrieval to improve the accuracy of the context fed to the LLM.

## Examples

**User Query:** "How do I chunk user manuals for a RAG chatbot?"

**Agent Execution:**
* **Strategy:** Use a Recursive Character Text Splitter.
* **Parameters:** Set chunk size to 512 tokens with an overlap of 50 tokens.
* **Metadata:** Attach metadata to each chunk containing the `manual_id`, `chapter_name`, and `page_number` so the chatbot can filter searches and cite its sources accurately.