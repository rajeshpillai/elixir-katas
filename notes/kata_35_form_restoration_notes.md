# Kata 35: Form Restoration

## Overview
LiveView is stateful. If the server crashes or redeploys, the state (memory) is lost.
Ideally, if a user has typed a long essay into a form and the server restarts, we should restore that text so they don't lose their work.

## Key Concepts

### 1. The `auto-recover` Form
Phoenix LiveView forms support an automatic recovery feature via the `phx-auto-recover` binding.
- **`phx-change="validate"`**: Sends changes to the server.
- **`phx-auto-recover="recover"`**: Typically same name as `phx-change`, but allows binding a specific event to restore inputs from the form data on reconnect.

### 2. Manual Recovery Strategy
However, a more robust way often involves **URL Params** or **Local Storage** (client-side) to persist drafts.
For this kata, we will demonstrate the simple server-side pattern:
1.  User types, `handle_event("validate", ...)` updates form state.
2.  If the process crashes (we will simulate this with a "Crash Me" button), the page reloads/reconnects.
3.  On reconnect, how do we get the data back?
    - **Standard HTML behavior**: Browsers often restore form inputs on refresh/back.
    - **LiveView Recovery**: If using `phx-change`, LiveView effectively "re-submits" the form's current input values on connection recovery to restore the server state.

## The Code Structure
We will add a button that raises an exception to simulate a crash.
We will see that because of `phx-change`, when the LiveView reconnects, the client sends the current input values again, and our `handle_event("validate", ...)` re-runs, restoring the state in the new process.

**Key takeaway**: By simply implementing `phx-change`, you get a degree of "form restoration" for free on reconnection because the client is the source of truth for the input values.
