# Kata 36: Debounce & Throttle

## Overview
When listening to keyboard events like `phx-change`, it's easy to overwhelm the server if we send a request for every single keystroke.
**Debouncing** ensures that we only send a request after the user has *stopped* typing for a specified duration.
**Throttling** ensures we send requests at most once every specified interval (e.g., for mouse movement or scroll events).

## Key Concepts

### 1. `phx-debounce`
LiveView makes this incredibly easy with the `phx-debounce` attribute on inputs.
- `phx-debounce="300"`: Wait 300ms after the last keystroke before sending the event.
- `phx-debounce="blur"`: Only send the event when the user leaves the field.

### 2. Loading States
When a search is triggered, it's polite to show a "Searching..." indicator.
We can use `phx-change` to trigger the search and manage an `@loading` state, or rely on LiveView's generic loading classes (`phx-submit-loading`, etc.) if using a form submit.

## The Code Structure
```html
<form phx-change="search" phx-submit="search">
  <input 
    type="text" 
    name="query" 
    phx-debounce="500" 
    placeholder="Search..." 
  />
</form>
```
In the LiveView:
```elixir
def handle_event("search", %{"query" => query}, socket) do
  # This only fires after 500ms of inactivity
  results = search(query) 
  {:noreply, assign(socket, results: results)}
end
```
