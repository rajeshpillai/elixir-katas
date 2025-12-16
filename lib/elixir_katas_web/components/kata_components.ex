defmodule ElixirKatasWeb.KataComponents do
  use ElixirKatasWeb, :html

  attr :active_tab, :string, required: true
  attr :title, :string, required: true
  attr :source_code, :string, required: true
  attr :notes_content, :string, required: true
  slot :inner_block, required: true
  
  def kata_viewer(assigns) do
    ~H"""
    <div class="flex flex-col h-full">
      <div class="flex items-center justify-between border-b border-zinc-200 dark:border-zinc-700 px-4 py-2">
        <h2 class="text-xl font-bold">{@title}</h2>
        
        <div class="flex gap-2">
          <.tab_button active={@active_tab == "interactive"} phx-click="set_tab" phx-value-tab="interactive">
            Interactive
          </.tab_button>
          <.tab_button active={@active_tab == "source"} phx-click="set_tab" phx-value-tab="source">
            Source Code
          </.tab_button>
          <.tab_button active={@active_tab == "notes"} phx-click="set_tab" phx-value-tab="notes">
            Notes
          </.tab_button>
        </div>
      </div>

      <div class="flex-1 overflow-auto p-4">
        <%= case @active_tab do %>
          <% "interactive" -> %>
            {render_slot(@inner_block)}
          
          <% "source" -> %>
            <div class="mockup-code w-full">
              <pre><code>{@source_code}</code></pre>
            </div>

          <% "notes" -> %>
            <div class="prose dark:prose-invert max-w-none">
              {raw Earmark.as_html!(@notes_content)}
            </div>
        <% end %>
      </div>
    </div>
    """
  end

  attr :active, :boolean, default: false
  attr :rest, :global
  slot :inner_block

  def tab_button(assigns) do
    ~H"""
    <button
      class={[
        "px-4 py-2 rounded-lg text-sm font-medium transition-colors",
        if(@active, do: "bg-primary text-white", else: "hover:bg-zinc-100 dark:hover:bg-zinc-800")
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
