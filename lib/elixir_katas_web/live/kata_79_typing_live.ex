defmodule ElixirKatasWeb.Kata79TypingIndicatorLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_79_typing_notes.md")

    socket =
      socket
      |> assign(active_tab: "interactive")
      |> assign(source_code: source_code)
      |> assign(notes_content: notes_content)
      |> assign(:typing, false)
      |> assign(:message, "")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata 79: Typing Indicator" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <div class="p-6 max-w-2xl mx-auto">
        <div class="mb-6 text-sm text-gray-500">
          Show typing indicator when user is typing.
        </div>

        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <div class="mb-4 h-20 flex items-center">
            <%= if @typing do %>
              <div class="flex items-center gap-2 text-gray-500">
                <div class="flex gap-1">
                  <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0ms"></span>
                  <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 150ms"></span>
                  <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 300ms"></span>
                </div>
                <span class="text-sm">Someone is typing...</span>
              </div>
            <% else %>
              <div class="text-gray-400 text-sm">Start typing to see the indicator</div>
            <% end %>
          </div>
          
          <input 
            type="text" 
            phx-keyup="typing"
            phx-debounce="300"
            value={@message}
            placeholder="Type something..."
            class="w-full px-4 py-2 border rounded"
          />
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_event("typing", %{"value" => value}, socket) do
    typing = String.length(value) > 0
    {:noreply, assign(socket, typing: typing, message: value)}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
