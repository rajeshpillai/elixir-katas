defmodule ElixirKatasWeb.Kata78ChatRoomLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_78_chat_notes.md")

    socket =
      socket
      |> assign(active_tab: "interactive")
      |> assign(source_code: source_code)
      |> assign(notes_content: notes_content)
      |> assign(:messages, [])
      |> assign(:message_input, "")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata 78: Chat Room" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <div class="p-6 max-w-2xl mx-auto">
        <div class="mb-6 text-sm text-gray-500">
          Simple chat room with message broadcasting.
        </div>

        <div class="bg-white rounded-lg shadow-sm border">
          <div class="h-96 overflow-y-auto p-4 space-y-2">
            <%= if Enum.empty?(@messages) do %>
              <div class="text-center text-gray-400 mt-20">
                No messages yet. Start chatting!
              </div>
            <% else %>
              <%= for {msg, idx} <- Enum.with_index(@messages) do %>
                <div class="flex gap-2">
                  <div class="flex-shrink-0 w-8 h-8 bg-indigo-500 rounded-full flex items-center justify-center text-white text-sm">
                    <%= String.first(msg.user) %>
                  </div>
                  <div class="flex-1">
                    <div class="text-sm font-medium"><%= msg.user %></div>
                    <div class="text-gray-700"><%= msg.text %></div>
                    <div class="text-xs text-gray-400"><%= msg.time %></div>
                  </div>
                </div>
              <% end %>
            <% end %>
          </div>
          <div class="border-t p-4">
            <form phx-submit="send_message" class="flex gap-2">
              <input 
                type="text" 
                name="message" 
                value={@message_input}
                placeholder="Type a message..."
                class="flex-1 px-4 py-2 border rounded"
              />
              <button type="submit" class="px-6 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700">
                Send
              </button>
            </form>
          </div>
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_event("send_message", %{"message" => text}, socket) when text != "" do
    message = %{
      user: "User",
      text: text,
      time: Calendar.strftime(DateTime.utc_now(), "%H:%M:%S")
    }
    
    {:noreply, 
     socket
     |> assign(:messages, socket.assigns.messages ++ [message])
     |> assign(:message_input, "")}
  end

  def handle_event("send_message", _, socket), do: {:noreply, socket}

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
