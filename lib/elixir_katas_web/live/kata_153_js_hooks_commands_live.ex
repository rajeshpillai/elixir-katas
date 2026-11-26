defmodule ElixirKatasWeb.Kata153JsHooksCommandsLive do
  @moduledoc """
  Lesson 13: JS Hooks & Commands

  Key concepts:
  - JS Hooks for client-side behavior (phx-hook)
  - JS Commands (Phoenix.LiveView.JS) for DOM manipulation without roundtrips
  - push_event/3 for server → client communication
  - handle_event for client → server via pushEvent
  - Combining JS commands for complex interactions

  Ported from phoenix-liveview-tutorial (lesson13_js_hooks_live.ex).
  In the tutorial this is a full LiveView; here it runs as a LiveComponent
  inside the kata host LiveView. `this.pushEvent` from a hook goes to the
  host LiveView, which forwards it here as `update(%{event: _, params: _})`.
  The hooks are registered globally in `assets/js/hooks/liveview_lab.js`.
  """
  use ElixirKatasWeb, :live_component

  # Events pushed by JS hooks (e.g. KeyListener's "key_pressed"), forwarded
  # by the host LiveView.
  @impl true
  def update(%{event: event, params: params}, socket) do
    {:noreply, socket} = handle_event(event, params, socket)
    {:ok, socket}
  end

  def update(assigns, socket) do
    if socket.assigns[:__initialized__] do
      {:ok, assign(socket, assigns)}
    else
      {:ok, socket |> assign(assigns) |> assign(:__initialized__, true) |> init()}
    end
  end

  defp init(socket) do
    socket
    |> assign(
      clipboard_text: "Hello from LiveView! Copy me.",
      server_events: [],
      js_toggle_open: false
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <h1 class="text-2xl font-bold">JS Hooks & Commands</h1>

      <%!-- SECTION 1: JS Commands --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">JS Commands (No Server Roundtrip)</h2>
          <p class="text-sm opacity-70">
            <code>Phoenix.LiveView.JS</code> runs DOM operations client-side.
            No WebSocket message needed.
          </p>

          <div class="space-y-3 mt-3">
            <%!-- Toggle --%>
            <div>
              <button
                phx-click={JS.toggle(to: "#kata153-js-toggle-target", in: "fade-in", out: "fade-out")}
                class="btn btn-sm btn-primary"
              >
                JS.toggle — Show/Hide
              </button>
              <div id="kata153-js-toggle-target" class="mt-2 p-3 bg-base-300 rounded text-sm">
                This element toggles with a CSS transition. No server involved!
              </div>
            </div>

            <%!-- Push/Remove class --%>
            <div>
              <button
                phx-click={
                  JS.add_class("bg-primary text-primary-content rounded p-2",
                    to: "#kata153-class-target"
                  )
                }
                class="btn btn-sm btn-secondary"
              >
                Add Classes
              </button>
              <button
                phx-click={
                  JS.remove_class("bg-primary text-primary-content rounded p-2",
                    to: "#kata153-class-target"
                  )
                }
                class="btn btn-sm btn-outline"
              >
                Remove Classes
              </button>
              <div id="kata153-class-target" class="mt-2 text-sm transition-all">
                Target element for class manipulation
              </div>
            </div>

            <%!-- Chained commands --%>
            <div>
              <button
                phx-click={
                  JS.push("server_ping", target: @myself)
                  |> JS.toggle(to: "#kata153-chain-indicator")
                  |> JS.transition("animate-pulse", to: "#kata153-chain-indicator")
                }
                class="btn btn-sm btn-accent"
              >
                Chained: push + toggle + transition
              </button>
              <div id="kata153-chain-indicator" class="mt-2 p-2 bg-accent/20 rounded text-sm" hidden>
                Server was pinged AND this element was toggled — in one click!
              </div>
            </div>
          </div>
        </div>
      </div>

      <%!-- SECTION 2: JS Hooks --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">JS Hooks (phx-hook)</h2>
          <p class="text-sm opacity-70">
            Hooks bridge JavaScript ↔ LiveView. Define them in <code>app.js</code>
            and reference via <code>phx-hook="HookName"</code>.
          </p>

          <%!-- Clipboard hook --%>
          <div class="mt-3">
            <h3 class="font-semibold text-sm">Clipboard Hook</h3>
            <div class="flex gap-2 mt-1">
              <input
                type="text"
                value={@clipboard_text}
                class="input input-bordered input-sm flex-1"
                readonly
              />
              <button
                id="kata153-copy-btn"
                phx-hook="Clipboard"
                data-clipboard-text={@clipboard_text}
                class="btn btn-sm btn-outline"
              >
                Copy
              </button>
            </div>
          </div>

          <%!-- Timestamp hook --%>
          <div class="mt-3">
            <h3 class="font-semibold text-sm">Local Timestamp Hook</h3>
            <p class="text-xs opacity-70">
              Server sends UTC, hook converts to local time on the client.
            </p>
            <div
              id="kata153-local-time"
              phx-hook="LocalTime"
              data-utc={DateTime.utc_now() |> DateTime.to_iso8601()}
              class="mt-1 p-2 bg-base-300 rounded text-sm font-mono"
            >
              Loading local time...
            </div>
          </div>

          <%!-- Key listener hook --%>
          <div class="mt-3">
            <h3 class="font-semibold text-sm">Keyboard Event Hook</h3>
            <p class="text-xs opacity-70">
              Hook captures keystrokes and pushes them to the server via <code>pushEvent</code>.
              (Here the event reaches the kata host LiveView, which forwards it to this component.)
            </p>
            <div
              id="kata153-key-listener"
              phx-hook="KeyListener"
              tabindex="0"
              class="mt-1 p-3 bg-base-300 rounded text-sm font-mono focus:ring-2 ring-primary cursor-text"
            >
              Click here and type...
            </div>
          </div>
        </div>
      </div>

      <%!-- SECTION 3: push_event (server → client) --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">push_event (Server → Client)</h2>
          <p class="text-sm opacity-70">
            The server can push arbitrary events to JS hooks via <code>push_event/3</code>.
          </p>

          <button
            phx-click="trigger_confetti"
            phx-target={@myself}
            class="btn btn-sm btn-primary mt-2"
          >
            Push "confetti" event to client
          </button>

          <div
            id="kata153-confetti-target"
            phx-hook="ConfettiReceiver"
            class="mt-2 p-3 bg-base-300 rounded text-sm min-h-[40px]"
          >
            Waiting for server push...
          </div>
        </div>
      </div>

      <%!-- SECTION 4: Server events log --%>
      <div :if={@server_events != []} class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">Server Event Log</h2>
          <div class="space-y-1 max-h-32 overflow-y-auto">
            <div :for={evt <- Enum.reverse(@server_events)} class="text-xs font-mono opacity-70">
              {evt}
            </div>
          </div>
        </div>
      </div>

      <%!-- Teaching notes --%>
      <div class="card bg-info/10 border border-info/30">
        <div class="card-body text-sm space-y-2">
          <h3 class="font-bold">Key Takeaways</h3>
          <ul class="list-disc list-inside space-y-1 opacity-80">
            <li><code>JS.*</code> commands run client-side — no WebSocket roundtrip</li>
            <li>Commands are chainable: <code>JS.push() |> JS.toggle() |> JS.transition()</code></li>
            <li>
              Hooks: <code>mounted()</code>, <code>updated()</code>, <code>destroyed()</code>
              lifecycle
            </li>
            <li><code>this.pushEvent(name, payload)</code> — client → server</li>
            <li><code>push_event(socket, name, payload)</code> — server → client</li>
            <li><code>this.handleEvent(name, callback)</code> — hook listens for server pushes</li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  # -- Events --

  @impl true
  def handle_event("server_ping", _params, socket) do
    event = "[#{Time.utc_now() |> Time.truncate(:second)}] server_ping received"
    {:noreply, assign(socket, server_events: [event | socket.assigns.server_events])}
  end

  @impl true
  def handle_event("key_pressed", %{"key" => key}, socket) do
    event = "[#{Time.utc_now() |> Time.truncate(:second)}] Key pressed: #{key}"
    {:noreply, assign(socket, server_events: [event | socket.assigns.server_events])}
  end

  @impl true
  def handle_event("trigger_confetti", _params, socket) do
    socket =
      push_event(socket, "confetti", %{
        message: "Party time! 🎉",
        timestamp: System.system_time(:second)
      })

    event = "[#{Time.utc_now() |> Time.truncate(:second)}] Pushed confetti event to client"
    {:noreply, assign(socket, server_events: [event | socket.assigns.server_events])}
  end
end
