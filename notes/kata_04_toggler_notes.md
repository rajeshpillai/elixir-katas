# Kata 04: The Toggler

## Goal
The goal of this kata is to learn how to **conditionally render content** and apply **dynamic CSS classes** based on state.

## Core Concepts

### 1. Conditional Rendering
You can use standard Elixir `if` expressions in your HEEx templates to show or hide content.

```elixir
{if @show_details do}
  <div class="alert alert-info">Here are the details!</div>
{end}
```

### 2. Boolean State Toggling
A common pattern is to flip a boolean value in `handle_event`.

```elixir
def handle_event("toggle", _params, socket) do
  {:noreply, update(socket, :show_details, &(!&1))}
end
```

### 3. Dynamic Classes
You can interpolate strings into the `class` attribute to change styles dynamically.

```elixir
<div class={"card #{if @active, do: "bg-primary text-white", else: "bg-base-200"}"}>
  ...
</div>
```

Alternatively, you can use a list for cleaner logic:

```elixir
<div class={["card", @active && "bg-primary text-white"]}>
```

## Steps to Create

1.  **Define state**: Initialize `show_details` (boolean) and `theme` (string) in `mount/3`.
2.  **Render UI**:
    *   A button to toggle the details view.
    *   A section that only appears when `show_details` is true.
    *   A card that changes color when clicked.
3.  **Handle interaction**: Implement events to toggle the boolean and switch the theme.
