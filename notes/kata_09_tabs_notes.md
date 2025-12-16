# Kata 09: The Tabs

## The Goal
In this kata, we will build a tabbed interface. The user should be able to click on a tab header (like "Home", "Pricing", or "About") and see the corresponding content area update instantly.

## Key Concepts
- **Conditional Rendering**: Using Elixir's `case` or `if` to display different HTML blocks based on state.
- **Active State Tracking**: Storing the current tab's ID (e.g., `:home`) in the LiveView socket.
- **Event Handling**: Using `phx-click` to send the selected tab to the server.
- **Styling Active States**: Dynamically applying CSS classes to highlight the selected tab.

## The Solution
We'll use a single atom, `@active_tab`, to track which tab is currently selected.

```elixir
# 1. Initialize state
def mount(_params, _session, socket) do
  {:ok, assign(socket, selected_tab: :home)}
end

# 2. Handle tab clicks
def handle_event("set_tab", %{"tab" => tab}, socket) do
  # Convert string param to atom safely
  tab_atom = String.to_existing_atom(tab)
  {:noreply, assign(socket, selected_tab: tab_atom)}
end

# 3. Render based on state
def render(assigns) do
  ~H"""
  <div>
    <!-- Navigation -->
    <button phx-click="set_tab" phx-value-tab="home" class={if @selected_tab == :home, do: "active", else: ""}>Home</button>
    <button phx-click="set_tab" phx-value-tab="pricing" class={if @selected_tab == :pricing, do: "active", else: ""}>Pricing</button>

    <!-- Content -->
    <%= case @selected_tab do %>
      <% :home -> %>
        <p>Welcome Home!</p>
      <% :pricing -> %>
        <p>Our prices are low.</p>
    <% end %>
  </div>
  """
end
```

This pattern is fundamental for building "Single Page Application" (SPA) feels within LiveView. It allows for complex UI navigation without ever leaving the page or triggering a full browser refresh.
