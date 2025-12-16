# Kata 50: Functional Components

## Overview
Function components are reusable UI building blocks defined with `attr` and `slot`.
They're the foundation of component-based architecture in Phoenix LiveView.

## Key Concepts

### 1. Defining Attributes
Use `attr` to declare component props:
```elixir
attr :title, :string, required: true
attr :variant, :string, default: "primary"

def button(assigns) do
  ~H"""
  <button class={button_class(@variant)}>
    <%= @title %>
  </button>
  """
end
```

### 2. Slots
Slots allow passing content blocks:
```elixir
slot :inner_block, required: true

def card(assigns) do
  ~H"""
  <div class="card">
    <%= render_slot(@inner_block) %>
  </div>
  """
end
```

### 3. Named Slots
```elixir
slot :header
slot :footer

def panel(assigns) do
  ~H"""
  <div>
    <div class="header"><%= render_slot(@header) %></div>
    <div class="footer"><%= render_slot(@footer) %></div>
  </div>
  """
end
```
