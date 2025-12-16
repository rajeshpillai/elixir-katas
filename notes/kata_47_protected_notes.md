# Kata 47: Protected Routes

## Overview
Use `on_mount` callbacks to protect routes and redirect unauthenticated users.
This is a common pattern for authentication in LiveView apps.

## Key Concepts

### 1. `on_mount` Hook
Define a module that implements `on_mount/4`:
```elixir
defmodule MyAppWeb.UserAuth do
  def on_mount(:require_auth, _params, session, socket) do
    if session["user_id"] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
```

### 2. Applying to Routes
```elixir
live_session :authenticated, on_mount: MyAppWeb.UserAuth do
  live "/dashboard", DashboardLive
end
```

### 3. Simulated Auth
For this kata, we'll simulate authentication with a simple toggle.
