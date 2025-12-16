# Kata 45: Tabs with URL

## Overview
Syncing tab state to URL query parameters allows users to bookmark or share specific tab views.
This combines the tab pattern with URL state management.

## Key Concepts

### 1. Tab State in URL
Store the active tab in a query parameter:
```
?tab=profile
?tab=settings
```

### 2. Syncing on Click
When a tab is clicked, update the URL:
```elixir
def handle_event("switch_tab", %{"tab" => tab}, socket) do
  {:noreply, push_patch(socket, to: "?tab=#{tab}")}
end
```

### 3. Reading from URL
In `handle_params/3`, set the active tab:
```elixir
def handle_params(%{"tab" => tab}, _uri, socket) do
  {:noreply, assign(socket, active_tab: tab)}
end
```
