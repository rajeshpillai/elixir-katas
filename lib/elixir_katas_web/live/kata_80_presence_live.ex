defmodule ElixirKatasWeb.Kata80PresenceListLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_80_presence_notes.md")

    users = [
      %{id: 1, name: "Alice", status: "online", avatar: "A"},
      %{id: 2, name: "Bob", status: "online", avatar: "B"},
      %{id: 3, name: "Charlie", status: "away", avatar: "C"},
      %{id: 4, name: "Diana", status: "offline", avatar: "D"},
    ]

    socket =
      socket
      |> assign(active_tab: "interactive")
      |> assign(source_code: source_code)
      |> assign(notes_content: notes_content)
      |> assign(:users, users)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata 80: Presence List" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <div class="p-6 max-w-2xl mx-auto">
        <div class="mb-6 text-sm text-gray-500">
          Track who is online using Phoenix Presence.
        </div>

        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <h3 class="text-lg font-medium mb-4">Online Users</h3>
          <div class="space-y-2">
            <%= for user <- @users do %>
              <div class="flex items-center gap-3 p-3 bg-gray-50 rounded">
                <div class="relative">
                  <div class="w-10 h-10 bg-indigo-500 rounded-full flex items-center justify-center text-white font-medium">
                    <%= user.avatar %>
                  </div>
                  <div class={"absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-white " <>
                              case user.status do
                                "online" -> "bg-green-500"
                                "away" -> "bg-yellow-500"
                                "offline" -> "bg-gray-400"
                              end}>
                  </div>
                </div>
                <div class="flex-1">
                  <div class="font-medium"><%= user.name %></div>
                  <div class="text-sm text-gray-500 capitalize"><%= user.status %></div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
