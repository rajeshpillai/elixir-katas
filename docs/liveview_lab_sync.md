# LiveView Lab sync

"Section 11: LiveView Lab" (LiveView katas 141–153) is ported from
[phoenix-liveview-tutorial](https://github.com/rajeshpillai/phoenix-liveview-tutorial),
so that all the Elixir, Phoenix and LiveView material lives in this app.
The tutorial repo stays the source of truth for the lesson content.

| Kata | Upstream lesson | Kata file | Notes file |
|------|-----------------|-----------|------------|
| 141 | 1 Architecture | `kata_141_architecture_live.ex` | `kata_141_architecture_notes.md` |
| 142 | 2 Lifecycle Callbacks | `kata_142_lifecycle_live.ex` | `kata_142_lifecycle_notes.md` |
| 143 | 3 Assigns & Reactivity | `kata_143_assigns_reactivity_live.ex` | `kata_143_assigns_reactivity_notes.md` |
| 144 | 4 Events & Bindings | `kata_144_events_bindings_live.ex` | `kata_144_events_bindings_notes.md` |
| 145 | 5 Navigation & Routing | `kata_145_navigation_routing_live.ex` | `kata_145_navigation_routing_notes.md` |
| 146 | 6 Function Components | `kata_146_function_components_live.ex` | `kata_146_function_components_notes.md` |
| 147 | 7 Errors, Flash & Uploads | `kata_147_errors_flash_uploads_live.ex` | `kata_147_errors_flash_uploads_notes.md` |
| 148 | 8 Streams & Async | `kata_148_streams_async_live.ex` | `kata_148_streams_async_notes.md` |
| 149 | 9 Real-time Streaming | `kata_149_realtime_streaming_live.ex` | `kata_149_realtime_streaming_notes.md` |
| 150 | 10 Temporary Assigns | `kata_150_temporary_assigns_live.ex` | `kata_150_temporary_assigns_notes.md` |
| 151 | 11 LiveComponents | `kata_151_live_components_live.ex` | `kata_151_live_components_notes.md` |
| 152 | 12 PubSub & Presence | `kata_152_pubsub_presence_live.ex` | `kata_152_pubsub_presence_notes.md` |
| 153 | 13 JS Hooks & Commands | `kata_153_js_hooks_commands_live.ex` | `kata_153_js_hooks_commands_notes.md` |

## Syncing

```bash
mix liveview_lab.sync            # pull upstream, update notes + components, list changed lessons
mix liveview_lab.sync --check    # report only; fails if anything is behind
# re-port each lesson the task lists (see below), run the tests, then:
mix liveview_lab.sync --mark-synced
```

- **Notes** and the **lesson 11 components** are copied automatically with fixed
  rewrites. Don't edit them here; change them upstream and sync.
- **Lesson code** can't be copied as-is, because upstream lessons are full
  LiveViews and katas are LiveComponents compiled at runtime by
  `KataHostLive`. The task lists the lessons whose code changed; port those
  changes by hand using the rules below.
- **JS hooks** live in `assets/js/hooks/liveview_lab.js`. The task reports
  when upstream `assets/js/app.js` changes.
- The last synced upstream commit is in `priv/liveview_lab_sync.json`.

Then run `mix test test/elixir_katas_web/live/liveview_lab/`.

## Porting a lesson into a kata

Use `kata_141_architecture_live.ex` as the reference. Keep the lesson's markup,
text and behaviour as close to upstream as possible, so later diffs stay easy
to port.

1. **Module and `use`.** `defmodule ElixirKatasWeb.Kata1NN<Name>Live` with
   `use ElixirKatasWeb, :live_component`. Keep the upstream `@moduledoc` and add
   a line saying which lesson file it was ported from.
2. **`mount/3` becomes a one-time init in `update/2`.**
   ```elixir
   def update(assigns, socket) do
     if socket.assigns[:__initialized__] do
       {:ok, assign(socket, assigns)}
     else
       {:ok, socket |> assign(assigns) |> assign(:__initialized__, true) |> init()}
     end
   end
   ```
   `connected?(socket)` and `self()` work in `init/1`; `self()` is the host
   LiveView process. Drop `page_title`.
3. **Messages (`handle_info/2`).** The host forwards every unknown message to
   the kata with `send_update(..., info_msg: msg)`. Add this clause **before**
   the generic `update/2`, and keep the upstream `handle_info/2` functions as
   plain functions (no `@impl`):
   ```elixir
   def update(%{info_msg: msg}, socket) do
     {:noreply, socket} = handle_info(msg, socket)
     {:ok, socket}
   end
   ```
   Do **not** use `Task.async/1` + awaiting a reply message: the host treats
   any `{ref, result}` message as a compile result. Use `Process.send_after/3`,
   `start_async/3` or `assign_async/3` instead (they work in components).
4. **Events.** Add `phx-target={@myself}` to every `phx-click`, `phx-submit`,
   `phx-change`, `phx-keydown`/`phx-keyup`, `phx-blur`/`phx-focus` binding and
   to forms. Events pushed by JS hooks (`this.pushEvent`) reach the host, which
   forwards them as `update(%{event: name, params: params}, socket)`; add that
   clause and call the upstream `handle_event/3`.
5. **URL params (`handle_params/3`).** The host passes its params to the kata as
   the `params` assign on every patch. React to them in `update/2`, and
   `push_patch` to `"/liveview-katas/<slug>?..."` (the kata's own URL).
   Navigation to other lessons (`/lessons/...`) becomes `/liveview-katas/<slug>`.
6. **Layout bits.** Remove the `<Layouts.app>` wrapper and the
   "← Home" / "View Notes" links; the kata page has its own tabs.
7. **Shared modules.** `LiveviewLab.PubSub` → `ElixirKatas.PubSub` (prefix topics
   with `"liveview_lab:"`), Presence → `ElixirKatasWeb.Presence`, lesson 11
   components → `ElixirKatasWeb.LiveviewLab.CounterComponent` /
   `EditableCardComponent`. Don't define extra modules inside a kata file: a
   user's edit would recompile them for everyone.
8. **Unique DOM ids.** Prefix ids that upstream used at page level, since the
   kata renders inside a larger page.
9. **Tests.** Add `test/elixir_katas_web/live/liveview_lab/kata_1NN_test.exs`
   that drives the main interactions through `live/2`, and make sure the
   section smoke test in `liveview_lab_test.exs` passes.

### Things that behave differently in a kata

Found while porting; check for them when re-porting.

- **The component remounts on every tab switch.** The kata page only renders
  the demo on the Interactive tab, so `init/1` runs again in the same host
  process each time the user comes back. Side effects in `init/1` must be safe
  to repeat: unsubscribe before subscribing, accept
  `{:error, {:already_tracked, ...}}` from Presence, and derive per-user ids
  from `self()` rather than `:rand` (see kata 152). State such as logs and
  running timers resets.
- **`terminate/2` does not exist for components.** For "user left" events,
  track the host process with `ElixirKatasWeb.Presence` and handle the
  `"presence_diff"` leaves (see kata 152).
- **Flash from a component does not reach the layout.** In LiveView 1.2 a
  component's `put_flash` is only copied to the parent on `push_patch` or
  `push_navigate`. Render `<.flash>` inside the kata instead (see kata 147).
- **A patch to the current URL does not reach the kata.** The host's params
  don't change, so `update/2` isn't called; anything that counts
  `handle_params` calls differs from upstream (see katas 142 and 145).
- **Window key events** (`phx-window-keydown`) only fire while the Interactive
  tab is shown.
- **Forwarded messages arrive one message later.** The host re-sends them with
  `send_update`, so tests must poll (`render/1` in a short loop) rather than
  assert right after `send/2`.
