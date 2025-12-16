# Kata 46: Search with URL

## Overview
Storing search queries in the URL enables deep linking to search results.
Users can bookmark or share specific search states.

## Key Concepts

### 1. Search Query in URL
```
?q=elixir
?q=phoenix&category=framework
```

### 2. Debounced URL Updates
Combine debouncing with URL updates for better UX:
```elixir
def handle_event("search", %{"q" => query}, socket) do
  # Debounce is handled by phx-debounce in template
  {:noreply, push_patch(socket, to: "?q=#{URI.encode(query)}")}
end
```

### 3. Initial Load from URL
```elixir
def handle_params(%{"q" => query}, _uri, socket) do
  results = search(query)
  {:noreply, assign(socket, query: query, results: results)}
end
```
