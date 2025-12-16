# Kata 37: The Wizard

## Overview
A **Wizard** splits a complex form into multiple steps (e.g., "Account Info" -> "Profile Details" -> "Review").
This reduces cognitive load and allows validating one section at a time.

## Key Concepts

### 1. Step Management
We need to track the `current_step` in `socket.assigns`.
- Step 1: User enters data.
- "Next": Validate current step's data. If valid, merge into `final_data` and increment `current_step`.
- "Back": Decrement `current_step`.

### 2. Preserving State across Steps
Since each step might be its own mini-form, we need a place to store the accumulated valid data.
- `socket.assigns.wizard_data`: A map holding `{name: "...", email: "...", bio: "..."}` as we progress.

### 3. Rendering
We can use a simple `case` statement in `render` to show the correct form for the current step.

## The Code Structure
```elixir
def render(assigns) do
  ~H\"\"\"
  <%= case @current_step do %>
    <% 1 -> %> <.step_one_form ... />
    <% 2 -> %> <.step_two_form ... />
    <% 3 -> %> <.review_step ... />
  <% end %>
  \"\"\"
end

def handle_event("next", params, socket) do
  # Validate params for this step
  # If valid:
  new_data = Map.merge(socket.assigns.wizard_data, params)
  {:noreply, assign(socket, wizard_data: new_data, current_step: 2)}
end
```
