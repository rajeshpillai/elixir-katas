# Kata 34: Live Feedback

## Overview
Showing validation errors *instantly* (as the user types) is great, but showing them *too early* (before the user has even finished the first word) feels aggressive and broken.

**Live Feedback** manages this UX by tracking which fields have been "touched" (focused and blurred, or edited). We only show errors for fields that the user has interacted with or after a failed submit attempt.

## Key Concepts

### 1. The `used_input?` pattern
Phoenix `Phoenix.HTML.Form` utilizes the `used_input?` helper (often implicitly via `to_form`'s `:as` or `:action` logic) to decide when to show errors.
However, in a manual LiveView context without Ecto Changesets, the easiest pattern is to explicitly track a set of `touched` fields.

### 2. Events: `phx-blur`
We use `phx-blur` on inputs to detect when a user *leaves* a field. This is the classic "touched" signal.
We accumulate these field names in a `MapSet` or list in `socket.assigns.touched`.

### 3. Logic
- **Initial Load**: No errors shown.
- **Typing (`phx-change`)**: Update value, run validation logic, but *don't* show errors unless field is already in `touched` set.
- **Blur (`phx-blur`)**: Add field to `touched` set. Now errors for this field become visible.
- **Submit**: Mark *all* fields as touched, so any remaining errors light up.

## The Code Structure
```elixir
def handle_event("blur", %{"name" => field}, socket) do
  # Add field to touched set
  touched = MapSet.put(socket.assigns.touched, field)
  {:noreply, assign(socket, touched: touched, form: ...)} 
end
```
In the template, we manually check:
```elixir
<%= if MapSet.member?(@touched, "username") and @form[:username].errors != [] do %>
  <.error>...</.error>
<% end %>
```
