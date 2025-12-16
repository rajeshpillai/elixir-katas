# Kata 43: The Nav Bar

## Overview
Active link highlighting helps users understand their current location in the app.
We can use the current URI from `handle_params/3` to determine which link is active.

## Key Concepts

### 1. Current URI
The second parameter in `handle_params/3` is the current URI:
```elixir
def handle_params(_params, uri, socket) do
  {:noreply, assign(socket, current_uri: uri)}
end
```

### 2. Active Link Styling
Compare the link's path with the current URI:
```elixir
class={if String.contains?(@current_uri, "/dashboard"), do: "active", else: ""}
```

### 3. Using `@socket.view`
You can also check the current LiveView module:
```elixir
active={@socket.view == ElixirKatasWeb.DashboardLive}
```

## The Code Structure
```elixir
def render(assigns) do
  ~H"""
  <nav>
    <.link navigate="/home" class={nav_link_class(@current_path, "/home")}>
      Home
    </.link>
    <.link navigate="/about" class={nav_link_class(@current_path, "/about")}>
      About
    </.link>
  </nav>
  """
end

defp nav_link_class(current, target) do
  if String.starts_with?(current, target) do
    "text-indigo-600 font-bold"
  else
    "text-gray-600"
  end
end
```
