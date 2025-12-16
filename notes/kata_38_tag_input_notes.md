# Kata 38: The Tag Input

## Overview
A **Tag Input** allows users to enter multiple values (like "elixir", "phoenix", "liveview") into a single visual field. Values are typically separated by commas or the Enter key and displayed as "pills" or "chips".

## Key Concepts

### 1. Separation of Input vs. Values
We maintain two pieces of state:
- `tags`: A list of validated strings (e.g., `["elixir", "phoenix"]`).
- `current_input`: The text currently being typed by the user (e.g., "live..").

### 2. Events
- **`phx-keyup`**: We listen for specific keys (Enter, Comma, Space) on the text input.
- **`phx-click="remove_tag"`**: Each tag pill has an "x" button to remove itself from the list.

### 3. Preventing Default Submission
When pressing "Enter" in a form input, the browser defaults to submitting the form. We need `onsubmit="return false;"` or `phx-keydown` handling to prevent this if we want Enter to just add a tag.

## The Code Structure
```elixir
def handle_event("keydown", %{"key" => "Enter", "value" => value}, socket) do
  new_tag = String.trim(value)
  if new_tag != "" do
    {:noreply, assign(socket, tags: [new_tag | socket.assigns.tags], current_input: "")}
  else
    {:noreply, socket}
  end
end
```
