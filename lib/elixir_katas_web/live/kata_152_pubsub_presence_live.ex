defmodule ElixirKatasWeb.Kata152PubsubPresenceLive do
  @moduledoc """
  Lesson 12: PubSub & Presence

  Key concepts:
  - Phoenix.PubSub for cross-process communication
  - Broadcasting events to all connected LiveViews
  - Shared state patterns (live counters, collaborative editing hints)
  - Topic-based pub/sub architecture

  Ported from phoenix-liveview-tutorial (lesson12_pubsub_live.ex).
  In the tutorial this is a full LiveView; here it runs as a LiveComponent
  inside the kata host LiveView. The host subscribes (`self()` is the host
  process) and forwards every broadcast here as `info_msg`.

  LiveComponents have no `terminate/2`, so instead of broadcasting
  `:user_left` from `terminate/2` this kata tracks the host process with
  `ElixirKatasWeb.Presence`. When the host process exits, Presence broadcasts
  a `"presence_diff"` with the user in `leaves`, which becomes `:user_left`.
  """
  use ElixirKatasWeb, :live_component

  @topic "liveview_lab:lesson5:lobby"

  # Messages the host LiveView forwards (PubSub broadcasts, presence diffs).
  @impl true
  def update(%{info_msg: msg}, socket) do
    {:noreply, socket} = handle_info(msg, socket)
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
    # Upstream picks a random id in mount/3. Here the component is mounted
    # again in the same host process whenever the Interactive tab is shown, so
    # derive the id from the host process to keep one identity per LiveView.
    user_id = "user-#{:erlang.phash2(self(), 10_000)}"

    if connected?(socket) do
      # Unsubscribe first so a remount never delivers each broadcast twice.
      Phoenix.PubSub.unsubscribe(ElixirKatas.PubSub, @topic)
      Phoenix.PubSub.subscribe(ElixirKatas.PubSub, @topic)

      # Replaces upstream's terminate/2: Presence untracks the host process
      # when it exits and broadcasts the leave on @topic.
      case ElixirKatasWeb.Presence.track(self(), @topic, user_id, %{}) do
        {:ok, _} -> broadcast(:user_joined, %{user_id: user_id})
        {:error, {:already_tracked, _, _, _}} -> :ok
      end
    end

    socket
    |> assign(
      user_id: user_id,
      shared_count: 0,
      messages: [],
      online_users: [],
      form: to_form(%{"message" => ""})
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <h1 class="text-2xl font-bold">PubSub & Multi-User Real-time</h1>
      <p class="text-sm opacity-70">
        Open this page in multiple browser tabs to see real-time sync.
        Your ID: <code class="badge badge-sm">{@user_id}</code>
      </p>

      <%!-- SECTION 1: Shared counter --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">Shared Counter (PubSub Broadcast)</h2>
          <p class="text-sm opacity-70">
            Every tab sees the same counter. Clicks broadcast to all connected LiveViews
            via <code>Phoenix.PubSub.broadcast/3</code>.
          </p>

          <div class="flex items-center gap-4 mt-3">
            <button phx-click="decrement" phx-target={@myself} class="btn btn-circle btn-outline">−</button>
            <span class="text-4xl font-bold font-mono min-w-[3ch] text-center">
              {@shared_count}
            </span>
            <button phx-click="increment" phx-target={@myself} class="btn btn-circle btn-outline">+</button>
          </div>
        </div>
      </div>

      <%!-- SECTION 2: Live chat --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">Live Chat (Broadcast Messages)</h2>
          <p class="text-sm opacity-70">
            Messages broadcast to the <code>liveview_lab:lesson5:lobby</code> topic.
            All subscribers receive them instantly.
          </p>

          <div
            class="mt-2 p-3 bg-base-300 rounded max-h-48 overflow-y-auto space-y-1"
            id="kata152-chat-messages"
          >
            <div :for={msg <- @messages} class="text-sm">
              <span class={[
                "font-mono font-bold",
                msg.user_id == @user_id && "text-primary"
              ]}>
                {msg.user_id}:
              </span>
              <span>{msg.text}</span>
            </div>
            <div :if={@messages == []} class="text-sm opacity-40">No messages yet...</div>
          </div>

          <.form for={@form} phx-submit="send_message" phx-target={@myself} class="flex gap-2 mt-2">
            <input
              type="text"
              name="message"
              value={@form[:message].value}
              placeholder="Type a message..."
              class="input input-bordered input-sm flex-1"
            />
            <button type="submit" class="btn btn-primary btn-sm">Send</button>
          </.form>
        </div>
      </div>

      <%!-- SECTION 3: Activity feed --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">Activity Feed</h2>
          <p class="text-sm opacity-70">
            Join/leave events are broadcast. Each LiveView's <code>terminate/2</code>
            callback notifies others.
          </p>
          <p class="text-xs opacity-60">
            In this kata the demo is a LiveComponent, which has no <code>terminate/2</code>,
            so leaves come from <code>Phoenix.Presence</code> tracking the LiveView process.
          </p>

          <div class="mt-2 space-y-1">
            <div :for={user <- @online_users} class="flex items-center gap-2 text-sm">
              <span class="badge badge-success badge-xs"></span>
              <span class={user == @user_id && "font-bold"}>{user}</span>
              <span :if={user == @user_id} class="text-xs opacity-50">(you)</span>
            </div>
            <div :if={@online_users == []} class="text-sm opacity-40">No users tracked yet</div>
          </div>
        </div>
      </div>

      <%!-- Teaching notes --%>
      <div class="card bg-info/10 border border-info/30">
        <div class="card-body text-sm space-y-2">
          <h3 class="font-bold">Key Takeaways</h3>
          <ul class="list-disc list-inside space-y-1 opacity-80">
            <li>
              <code>PubSub.subscribe/2</code>
              in <code>mount/3</code>
              (only when <code>connected?/1</code>)
            </li>
            <li><code>PubSub.broadcast/3</code> sends to ALL subscribers (including self)</li>
            <li><code>handle_info/2</code> receives broadcast messages</li>
            <li><code>terminate/2</code> for cleanup (user left notifications)</li>
            <li>For real presence tracking, use <code>Phoenix.Presence</code></li>
            <li>Topics are strings — namespace them like <code>"room:lobby"</code></li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  # -- Events --

  @impl true
  def handle_event("increment", _params, socket) do
    broadcast(:count_changed, %{delta: 1})
    {:noreply, socket}
  end

  @impl true
  def handle_event("decrement", _params, socket) do
    broadcast(:count_changed, %{delta: -1})
    {:noreply, socket}
  end

  @impl true
  def handle_event("send_message", %{"message" => msg}, socket) when byte_size(msg) > 0 do
    broadcast(:new_message, %{user_id: socket.assigns.user_id, text: msg})
    {:noreply, assign(socket, form: to_form(%{"message" => ""}))}
  end

  def handle_event("send_message", _params, socket), do: {:noreply, socket}

  # -- PubSub handlers --

  def handle_info({:count_changed, %{delta: delta}}, socket) do
    {:noreply, assign(socket, shared_count: socket.assigns.shared_count + delta)}
  end

  def handle_info({:new_message, msg}, socket) do
    messages = Enum.take(socket.assigns.messages ++ [msg], -50)
    {:noreply, assign(socket, messages: messages)}
  end

  def handle_info({:user_joined, %{user_id: uid}}, socket) do
    users = Enum.uniq(socket.assigns.online_users ++ [uid])
    {:noreply, assign(socket, online_users: users)}
  end

  def handle_info({:user_left, %{user_id: uid}}, socket) do
    users = List.delete(socket.assigns.online_users, uid)
    {:noreply, assign(socket, online_users: users)}
  end

  # Presence diffs (replace upstream's terminate/2 leave broadcast). Joins
  # are already announced with :user_joined, so only leaves are handled.
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    Enum.reduce(Map.keys(diff.leaves), {:noreply, socket}, fn uid, {:noreply, socket} ->
      handle_info({:user_left, %{user_id: uid}}, socket)
    end)
  end

  # -- Helpers --

  defp broadcast(event, payload) do
    Phoenix.PubSub.broadcast(ElixirKatas.PubSub, @topic, {event, payload})
  end
end
