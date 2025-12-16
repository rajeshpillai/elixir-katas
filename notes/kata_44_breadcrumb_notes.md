# Kata 44: The Breadcrumb

## Overview
Breadcrumbs show the navigation hierarchy and allow users to navigate back up the tree.
They're dynamically generated based on the current URL path.

## Key Concepts

### 1. Path Parsing
Split the current URI path into segments:
```elixir
path = URI.parse(uri).path
segments = String.split(path, "/", trim: true)
```

### 2. Building Breadcrumb Trail
Create a list of `{label, path}` tuples:
```elixir
breadcrumbs = [
  {"Home", "/"},
  {"Products", "/products"},
  {"Electronics", "/products/electronics"}
]
```

### 3. Rendering
Render each breadcrumb with a separator, making the last one non-clickable:
```html
<%= for {label, path} <- @breadcrumbs do %>
  <.link navigate={path}><%= label %></.link>
  <span>/</span>
<% end %>
```
