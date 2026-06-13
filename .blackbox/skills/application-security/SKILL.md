---
name: application-security
description: Enforces secure coding practices, vulnerability mitigation, and cryptographic management to protect application integrity.
---

# Application Security

## Instructions
When writing code, reviewing architecture, or handling data, strictly adhere to security best practices:
1.  **Input Sanitization:** Never trust user input. Validate, escape, and sanitize all inputs to prevent Cross-Site Scripting (XSS) and SQL Injection (SQLi). Use parameterized queries or ORMs exclusively.
2.  **Authentication & Authorization:** Enforce the principle of least privilege. Implement secure session management, use HttpOnly cookies for JWTs, and apply Role-Based Access Control (RBAC).
3.  **Secret Management:** Never hardcode API keys, passwords, or tokens in the codebase. Always use environment variables (`.env`) or secret managers (e.g., AWS Secrets Manager).
4.  **Dependency Security:** Regularly audit dependencies. Do not implement custom cryptographic algorithms; use standard, vetted libraries (e.g., Argon2 or bcrypt for hashing).

## Examples

**User Query:** "Write a function to query a user by their username in PostgreSQL."

**Agent Execution:**
* **Implementation:** Write a parameterized query using a library like `pg` in Node.js or `psycopg2` in Python. 
* **Security Enforcement:** Explicitly reject string concatenation (`SELECT * FROM users WHERE username = '` + username + `'`) to prevent SQL injection vulnerabilities. Provide the safe `SELECT * FROM users WHERE username = $1` format instead.