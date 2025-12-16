# Kata 48: Live Redirects

## Overview
LiveView provides two navigation functions: `push_navigate` and `push_patch`.
Understanding when to use each is crucial for optimal UX.

## Key Concepts

### 1. `push_patch/2`
- Stays within the same LiveView
- Triggers `handle_params/3`
- Fast, no remount
- Use for: tabs, filters, pagination

```elixir
{:noreply, push_patch(socket, to: "?page=2")}
```

### 2. `push_navigate/2`
- Navigates to a different LiveView
- Full mount cycle
- Use for: different pages, different contexts

```elixir
{:noreply, push_navigate(socket, to: "/other-page")}
```

### 3. When to Use Which
- **Same LiveView, different state**: `push_patch`
- **Different LiveView**: `push_navigate`
- **External URL**: `redirect` (not covered here)
