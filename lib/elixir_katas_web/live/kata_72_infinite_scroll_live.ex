defmodule ElixirKatasWeb.Kata72InfiniteScrollLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  @per_page 10

  def mount(_params, _session, socket) do
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_72_infinite_scroll_notes.md")

    socket =
      socket
      |> assign(active_tab: "interactive")
      |> assign(source_code: source_code)
      |> assign(notes_content: notes_content)
      |> assign(:page, 1)
      |> assign(:has_more, true)
      |> load_items(1)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata 72: Infinite Scroll" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <div class="p-6 max-w-4xl mx-auto">
        <div class="mb-6 text-sm text-gray-500">
          Load more items by clicking the button (simulates infinite scroll).
        </div>

        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <div id="items-container" phx-update="stream" class="space-y-2 max-h-96 overflow-y-auto">
            <%= for {dom_id, item} <- @streams.items do %>
              <div id={dom_id} class="p-4 bg-gray-50 rounded">
                <div class="font-medium"><%= item.title %></div>
                <div class="text-sm text-gray-500">Item #<%= item.id %></div>
              </div>
            <% end %>
          </div>
          
          <%= if @has_more do %>
            <div class="mt-4 text-center">
              <button 
                phx-click="load-more" 
                class="px-6 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
              >
                Load More Items
              </button>
              <div class="text-xs text-gray-500 mt-2">
                Page <%= @page %> of 5
              </div>
            </div>
          <% else %>
            <div class="mt-4 text-center text-gray-500">
              All items loaded!
            </div>
          <% end %>
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_event("load-more", _, socket) do
    if socket.assigns.has_more do
      next_page = socket.assigns.page + 1
      {:noreply, load_items(socket, next_page)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end

  defp load_items(socket, page) do
    start_id = (page - 1) * @per_page + 1
    items = for i <- start_id..(start_id + @per_page - 1) do
      %{id: i, title: "Item #{i}"}
    end
    
    has_more = page < 5  # Limit to 5 pages for demo
    
    socket
    |> stream(:items, items)
    |> assign(:page, page)
    |> assign(:has_more, has_more)
  end
end
