# Kata 42: Path Params

## Overview
Dynamic route segments like `/user/:id` allow you to capture parts of the URL path as parameters.
These are accessed in `handle_params/3` just like query params.

## Key Concepts

### 1. Dynamic Routes
Define routes with `:param_name` syntax:
```elixir
live "/user/:id", UserLive
live "/posts/:category/:slug", PostLive
```

### 2. Accessing Path Params
Path params appear in the `params` map in `handle_params/3`:
```elixir
def handle_params(%{"id" => id}, _uri, socket) do
  user = get_user(id)
  {:noreply, assign(socket, user: user)}
end
```

### 3. Navigation with Path Params
```elixir
<.link navigate={~p"/user/#{user.id}"}>View User</.link>
```

## The Code Structure
```elixir
# Router
live "/items/:id", ItemLive

# LiveView
def handle_params(%{"id" => id}, _uri, socket) do
  item = Enum.find(socket.assigns.all_items, &(&1.id == String.to_integer(id)))
  {:noreply, assign(socket, selected_item: item)}
end
```
