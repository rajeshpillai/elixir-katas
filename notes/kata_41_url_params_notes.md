# Kata 41: URL Params

## Overview
LiveView provides `handle_params/3` to react to URL changes, including query string parameters.
This is essential for deep linking, shareable URLs, and maintaining state in the URL.

## Key Concepts

### 1. `handle_params/3`
This callback is invoked:
- On initial mount (after `mount/3`)
- When the URL changes via `push_patch` (same LiveView)
- When navigating with query params

```elixir
def handle_params(params, _uri, socket) do
  # params is a map of query string parameters
  # Example: ?page=2&sort=name becomes %{"page" => "2", "sort" => "name"}
  {:noreply, assign(socket, page: params["page"] || "1")}
end
```

### 2. `push_patch/2`
Updates the URL without remounting the LiveView:
```elixir
{:noreply, push_patch(socket, to: "/path?page=2")}
```

### 3. URL State Management
Query params are perfect for:
- Pagination (`?page=2`)
- Sorting (`?sort=name&order=asc`)
- Filtering (`?category=elixir`)
- Tab selection (`?tab=profile`)

## The Code Structure
```elixir
def handle_params(%{"filter" => filter}, _uri, socket) do
  items = filter_items(socket.assigns.all_items, filter)
  {:noreply, assign(socket, items: items, current_filter: filter)}
end

def handle_event("change_filter", %{"filter" => filter}, socket) do
  {:noreply, push_patch(socket, to: "?filter=#{filter}")}
end
```
