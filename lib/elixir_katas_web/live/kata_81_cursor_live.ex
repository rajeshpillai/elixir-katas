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
      |> assign(:last_update, "Not tracking yet")

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
          Click anywhere in the box below to track cursor position.
        </div>

        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <div 
            id="cursor-area"
            class="h-96 bg-gradient-to-br from-indigo-50 to-purple-50 rounded relative cursor-crosshair"
            phx-click="track_cursor"
          >
            <div class="absolute top-4 left-4 bg-white px-4 py-2 rounded-lg shadow-md">
              <div class="text-xs text-gray-500 mb-2">Click to track position</div>
              <div class="font-mono text-sm space-y-1">
                <div class="text-indigo-600 font-bold">X: <%= @cursor_x %> px</div>
                <div class="text-purple-600 font-bold">Y: <%= @cursor_y %> px</div>
              </div>
              <div class="text-xs text-gray-400 mt-2"><%= @last_update %></div>
            </div>
            
            <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center text-gray-400">
              <div class="text-lg mb-2">👆 Click anywhere in this area</div>
              <div class="text-sm">Position will be tracked</div>
            </div>
            
            <%= if @cursor_x > 0 or @cursor_y > 0 do %>
              <div 
                class="absolute w-4 h-4 bg-indigo-500 rounded-full pointer-events-none"
                style={"left: #{@cursor_x}px; top: #{@cursor_y}px; transform: translate(-50%, -50%);"}
              >
                <div class="absolute inset-0 bg-indigo-500 rounded-full animate-ping opacity-75"></div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_event("track_cursor", params, socket) do
    # Try to extract coordinates from various possible parameter names
    x = params["offsetX"] || params["clientX"] || params["pageX"] || 0
    y = params["offsetY"] || params["clientY"] || params["pageY"] || 0
    
    timestamp = Calendar.strftime(DateTime.utc_now(), "%H:%M:%S")
    
    {:noreply, 
     socket
     |> assign(:cursor_x, x)
     |> assign(:cursor_y, y)
     |> assign(:last_update, "Updated at #{timestamp}")}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
