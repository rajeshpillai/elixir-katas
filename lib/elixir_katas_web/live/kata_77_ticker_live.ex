defmodule ElixirKatasWeb.Kata77TheTickerLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_77_ticker_notes.md")

    if connected?(socket) do
      :timer.send_interval(2000, self(), :update_prices)
    end

    stocks = [
      %{symbol: "AAPL", name: "Apple Inc.", price: 150.00},
      %{symbol: "GOOGL", name: "Alphabet Inc.", price: 2800.00},
      %{symbol: "MSFT", name: "Microsoft Corp.", price: 380.00},
      %{symbol: "TSLA", name: "Tesla Inc.", price: 250.00},
    ]

    socket =
      socket
      |> assign(active_tab: "interactive")
      |> assign(source_code: source_code)
      |> assign(notes_content: notes_content)
      |> assign(:stocks, stocks)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata 77: The Ticker" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <div class="p-6 max-w-4xl mx-auto">
        <div class="mb-6 text-sm text-gray-500">
          Real-time stock price updates using server-side intervals.
        </div>

        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <h3 class="text-lg font-medium mb-4">Stock Ticker</h3>
          <div class="grid grid-cols-2 gap-4">
            <%= for stock <- @stocks do %>
              <div class="p-4 bg-gray-50 rounded-lg">
                <div class="flex justify-between items-start mb-2">
                  <div>
                    <div class="font-bold text-lg"><%= stock.symbol %></div>
                    <div class="text-sm text-gray-600"><%= stock.name %></div>
                  </div>
                  <div class="text-right">
                    <div class="text-2xl font-bold text-green-600">
                      $<%= :erlang.float_to_binary(stock.price, decimals: 2) %>
                    </div>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
          <div class="mt-4 text-xs text-gray-500 text-center">
            Prices update every 2 seconds
          </div>
        </div>
      </div>
    </.kata_viewer>
    """
  end

  def handle_info(:update_prices, socket) do
    updated_stocks = Enum.map(socket.assigns.stocks, fn stock ->
      # Simulate price change (-2% to +2%)
      change = ((:rand.uniform() - 0.5) * 0.04 * stock.price)
      %{stock | price: stock.price + change}
    end)
    
    {:noreply, assign(socket, :stocks, updated_stocks)}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
