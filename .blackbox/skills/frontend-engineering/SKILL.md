---
name: frontend-engineering
description: Enables the agent to build responsive, accessible, and highly interactive user interfaces using modern web frameworks.
---

# Frontend Engineering

## Instructions
When tasked with UI/UX implementation, component creation, or client-side logic:
1.  **Component Architecture:** Build declarative, reusable, and isolated components (e.g., React hooks, Vue composition API).
2.  **State Management:** Differentiate between local UI state (useState) and global application state (Redux, Zustand, Context).
3.  **Styling:** Use utility-first CSS (Tailwind) or CSS-in-JS for scoped, maintainable styling. Ensure layouts are mobile-responsive by default.
4.  **Accessibility (a11y):** Apply semantic HTML tags and ARIA labels. Ensure keyboard navigability and high contrast ratios.

## Examples

**User Query:** "Build a reusable button component in React."

**Agent Execution:**
* **Implementation:** Create a functional component accepting props for `variant` (primary, secondary, danger), `size`, `disabled`, and `onClick`.
* **Styling:** Apply conditional Tailwind classes based on the `variant` prop.
* **Accessibility:** Add `aria-disabled` if the button is in a loading or disabled state.