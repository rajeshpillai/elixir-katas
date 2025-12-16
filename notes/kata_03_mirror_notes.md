# Kata 03: The Mirror

## Goal
The goal of this kata is to understand **Form Bindings** and the `phx-change` event. You will create a text input that mirrors its content to another part of the page in real-time.

## Core Concepts

### 1. `phx-change`
Unlike `phx-click` which fires on a specific interaction, `phx-change` fires whenever a form input changes.

```html
<form phx-change="validate">
  <input type="text" name="text" />
</form>
```

### 2. Forms in LiveView
Even for a single input, it is best practice to wrap it in a `<form>` tag. This allows LiveView to handle the submission and change events correctly.

### 3. Handling params
The `handle_event` callback for `phx-change` receives the form data as a map.

```elixir
def handle_event("validate", %{"text" => text}, socket) do
  {:noreply, assign(socket, text: text)}
end
```

## Steps to Create

1.  **Define state**: Initialize `text` to an empty string in `mount/3`.
2.  **Render UI**: Create a form with a text input and a display area for the `@text`.
3.  **Handle interaction**: Implement `handle_event("validate", ...)` to update the state.

## Tips
- **Debounce**: You can use `phx-debounce="300"` on the input to limit how often the event is sent to the server. This is useful for search inputs or expensive operations.
- **Value Binding**: Ensure the input's `value` attribute is set to `{@text}` if you want the server to control the input content (controlled component).
