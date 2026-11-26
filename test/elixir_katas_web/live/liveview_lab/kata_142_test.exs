defmodule ElixirKatasWeb.LiveviewLab.Kata142Test do
  @moduledoc "Interaction tests for kata 142 (Lifecycle Callbacks)."
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/142-lifecycle"

  test "logs mount and handle_params on load", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path)

    assert html =~ "mount/3 called (connected=true)"
    assert html =~ "handle_params/3 — tab=mount"
    assert html =~ "Called once on static render (HTTP)"
  end

  test "the tab query param selects the tab", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path <> "?tab=events")

    assert html =~ "handle_params/3 — tab=events"
    assert html =~ "Handles client-side events"
    refute html =~ "Called once on static render (HTTP)"
  end

  test "patching to another tab runs handle_params", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element(~s|a[href="#{@path}?tab=info"]|) |> render_click()
    assert_patch(view, @path <> "?tab=info")

    html = render(view)
    assert html =~ "handle_params/3 — tab=info"
    assert html =~ "Receives messages from"
    assert html =~ "Active tab: <code>info</code>"
  end

  test "trigger event and send self message", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Trigger Event") |> render_click()
    assert html =~ "trigger_event"

    view |> element("button", "Send Self Message") |> render_click()
    html = render(view)
    assert html =~ "message dispatched via send/2"
    assert html =~ "handle_info/2 — received :self_message"
  end

  test "timer ticks via handle_info and stops", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Start Timer") |> render_click()
    assert html =~ "timer started (1s interval)"
    assert html =~ "Stop Timer"

    # Don't wait for the real timer: deliver a tick to the host LiveView,
    # which forwards it to the component.
    # The host forwards the message to the component with a second message,
    # so poll until it has been rendered.
    send(view.pid, :tick)
    html = eventually(view, &(&1 =~ ":tick #1"))
    assert html =~ "tick #1"

    html = view |> element("button", "Stop Timer") |> render_click()
    assert html =~ "timer stopped"
    assert html =~ "Start Timer"

    # The real 1s timer may also have fired on a slow machine, so compare the
    # tick count before and after instead of expecting an exact number.
    ticks_after_stop = tick_entries(html)
    send(view.pid, :tick)
    assert tick_entries(render(view)) == ticks_after_stop
  end

  defp tick_entries(html), do: length(Regex.scan(~r/:tick #\d+/, html))

  defp eventually(view, fun, attempts \\ 50) do
    html = render(view)

    cond do
      fun.(html) -> html
      attempts == 0 -> flunk("condition not met; last render:\n" <> html)
      true -> Process.sleep(10) && eventually(view, fun, attempts - 1)
    end
  end

  test "clear log empties the log", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Clear Log") |> render_click()
    assert html =~ "No log entries yet..."
    refute html =~ "mount/3 called"
  end
end
