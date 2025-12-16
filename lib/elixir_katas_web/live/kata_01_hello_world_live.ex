defmodule ElixirKatasWeb.Kata01HelloWorldLive do
  use ElixirKatasWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="prose dark:prose-invert">
      <h1>Kata 01: Hello World</h1>
      <p>Welcome to your first Elixir LiveView Kata!</p>
      
      <div class="mockup-code">
        <pre data-prefix="$"><code>iex</code></pre> 
        <pre data-prefix=">"><code>IO.puts("Hello World")</code></pre> 
        <pre data-prefix="" class="text-success"><code>Hello World</code></pre>
      </div>

      <div class="mt-8 flex gap-4">
        <button phx-click="toggle" class="btn btn-primary">
          {if @clicked, do: "You clicked me!", else: "Click me!"}
        </button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, clicked: false)}
  end

  def handle_event("toggle", _params, socket) do
    {:noreply, update(socket, :clicked, &(!&1))}
  end
end
