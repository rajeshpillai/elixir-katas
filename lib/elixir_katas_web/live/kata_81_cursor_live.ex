defmodule ElixirKatasWeb.Kata81LiveCursorLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_81_cursor_notes.md")

    socket =
      socket
      |> assign(active_tab: "interactive")
      |> assign(source_code: source_code)
      |> assign(notes_content: notes_content)
      |> assign(:cursor_x, 0)
      |> assign(:cursor_y, 0)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata 81: Live Cursor" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <div class="p-6 max-w-2xl mx-auto">
        <div class="mb-6 text-sm text-gray-500">
          Track mouse cursor positions in real-time.
        </div>

        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <div 
            id="cursor-area"
            class="h-96 bg-gray-50 rounded relative cursor-crosshair"
            phx-window-mousemove="track_cursor"
          >
            <div class="absolute top-4 left-4 bg-white px-4 py-2 rounded shadow text-sm">
              X: <%= @cursor_x %>, Y: <%= @cursor_y %>
            </div>
            <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center text-gray-400">
              <div class="text-lg mb-2">Move your mouse</div>
              <div class="text-sm">Coordinates are tracked in real-time</div>
            </div>
          </div>
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_event("track_cursor", %{"clientX" => x, "clientY" => y}, socket) do
    {:noreply, assign(socket, cursor_x: x, cursor_y: y)}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
