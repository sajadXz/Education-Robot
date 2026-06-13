---
name: backend-development
description: Equips the agent to write robust, scalable server-side code, manage application state, and build resilient APIs.
---

# Backend Development

## Instructions
When tasked with writing server-side logic, APIs, or data processing pipelines, follow these directives:
1.  **Framework Selection:** Utilize the most efficient framework for the requested language (e.g., FastAPI for Python, NestJS/Express for Node.js, Gin for Go).
2.  **API Standards:** Enforce strict RESTful conventions or GraphQL schemas. Ensure standard HTTP status codes are used accurately.
3.  **Modularity:** Separate business logic from routing. Use controller-service-repository patterns to keep code testable and DRY (Don't Repeat Yourself).
4.  **Error Handling:** Implement global error handlers and never expose internal stack traces to the client.

## Examples

**User Query:** "Create a user registration endpoint in Node.js."

**Agent Execution:**
* **Routing:** Create a `POST /api/users/register` route using Express.
* **Validation:** Implement input validation (e.g., using Zod or Joi) to ensure email format and password strength.
* **Business Logic:** Hash the password using bcrypt before storing it.
* **Response:** Return a `201 Created` status with the user ID (excluding the password hash).