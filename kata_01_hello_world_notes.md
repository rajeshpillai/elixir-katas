# Kata 01: Hello World - Tutorial Notes

## Goal
The goal of this kata is to create a basic "Hello World" page using Phoenix LiveView. This introduces the core concepts of LiveView: rendering a template, maintaining state, and handling basic events.

## Steps to Create

### 1. Create the LiveView Module
Create a file named `lib/elixir_katas_web/live/kata_01_hello_world_live.ex`.

**Key Functions:**
- `mount/3`: Initializes the LiveView. We set the initial state here.
- `render/1`: Defines the UI using the `~H` sigil.
- `handle_event/3`: Handles user interactions (like clicks).

```elixir
defmodule ElixirKatasWeb.Kata01HelloWorldLive do
  use ElixirKatasWeb, :live_view

  # Initialize state
  def mount(_params, _session, socket) do
    {:ok, assign(socket, clicked: false)}
  end

  # Render the UI
  def render(assigns) do
    ~H"""
    <div class="prose dark:prose-invert">
      <h1>Kata 01: Hello World</h1>
      <button phx-click="toggle" class="btn btn-primary">
        {if @clicked, do: "You clicked me!", else: "Click me!"}
      </button>
    </div>
    """
  end

  # Handle the click event
  def handle_event("toggle", _params, socket) do
    {:noreply, update(socket, :clicked, &(!&1))}
  end
end
```

### 2. Add the Route
Open `lib/elixir_katas_web/router.ex` and add the live route inside the main scope:

```elixir
scope "/", ElixirKatasWeb do
  pipe_through :browser

  live "/katas/01", Kata01HelloWorldLive
end
```

## Tips
- **Sigils**: The `~H` sigil is used for HEEx (HTML + EEX) templates. It verifies your HTML structure at compile time.
- **Assigns**: Use `@variable` in the template to access data from the socket assigns.
- **Colocation**: Keeping the `render` function in the same file as the logic (as we did here) is great for small components. For larger ones, you might use a separate `.heex` file.

## Caveats
- **State**: LiveView state is held in memory on the server. Be mindful of what you store in `assigns`.
- **CSS Classes**: We used `prose` (Tailwind Typography) and `btn` (DaisyUI) classes. Ensure these libraries are configured in `assets/package.json` and `assets/tailwind.config.js` if you want the styles to appear.
