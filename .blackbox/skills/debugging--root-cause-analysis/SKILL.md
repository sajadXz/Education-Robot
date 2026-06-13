---
name: debugging--root-cause-analysis
description: Allows the agent to autonomously parse logs, tracebacks, and code logic to isolate and resolve systemic failures.
---

# Debugging & Root Cause Analysis

## Instructions
When presented with an error message, bug report, or failing test:
1.  **Analyze the Traceback:** Read the stack trace from the bottom up to identify the exact file and line number causing the crash.
2.  **Isolate the Variable:** Identify which variable or state is `undefined`, `null`, or out of bounds. 
3.  **Hypothesize & Verify:** Formulate a hypothesis for why the state is invalid before suggesting a code change. Do not guess; explain the logical disconnect.
4.  **Provide the Fix:** Output the corrected code snippet along with a brief explanation of how it prevents the error.

## Examples

**User Query:** "I'm getting a `TypeError: Cannot read properties of undefined (reading 'map')` in my React list component."

**Agent Execution:**
* **Analysis:** The array being passed to the `.map()` function is undefined at the time of rendering.
* **Fix:** Implement optional chaining (`data?.map(...)`) or provide a fallback empty array (`(data || []).map(...)`). Advise checking the data-fetching logic to ensure it initializes as an empty array rather than undefined.