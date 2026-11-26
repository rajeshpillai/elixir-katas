defmodule ElixirKatasWeb.LiveviewLab.Kata149Test do
  @moduledoc """
  Interaction tests for kata 149 (Real-time Streaming).

  The demos run for several seconds, so the tests check that the background
  tasks' first messages arrive, and then send the "done" message directly to
  the host LiveView (which forwards it to the kata) to check the end state.
  """
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/149-realtime-streaming"

  defp eventually(fun, timeout \\ 3000) do
    cond do
      fun.() ->
        true

      timeout <= 0 ->
        flunk("condition not met in time")

      true ->
        Process.sleep(20)
        eventually(fun, timeout - 20)
    end
  end

  test "token streaming appends tokens and finishes", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Click &quot;Start Streaming&quot; to begin..."

    html = view |> element("button", "Start Streaming") |> render_click()
    assert html =~ "Streaming..."

    eventually(fn -> render(view) =~ "Phoenix" end)
    assert has_element?(view, "button[disabled]", "Streaming...")

    send(view.pid, :stream_done)
    eventually(fn -> has_element?(view, "button:not([disabled])", "Start Streaming") end)
  end

  test "forwarded token messages build the text and Clear resets it", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    send(view.pid, {:token, "Hello, "})
    send(view.pid, {:token, "world"})
    eventually(fn -> render(view) =~ "Hello, world" end)

    view |> element("button[phx-click=clear_stream]") |> render_click()
    html = render(view)
    refute html =~ "Hello, world"
    assert html =~ "to begin..."
  end

  test "progress updates arrive from the background task", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Start Process") |> render_click()
    assert html =~ "Processing..."

    eventually(fn -> not (render(view) =~ ~r/<span>0%<\/span>/) end)
    assert render(view) =~ ~r/<span>[1-9]\d*%<\/span>/

    send(view.pid, :progress_done)
    eventually(fn -> has_element?(view, "button", "Start Process") end)
  end

  test "log lines stream into the ScrollBottom container and can be cleared", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "No log output yet..."
    assert has_element?(view, "#lvlab-streaming-log-container[phx-hook=ScrollBottom]")

    view |> element("button", "Generate Logs") |> render_click()
    eventually(fn -> render(view) =~ "(line 2)" end)
    assert render(view) =~ ~r/\[(INFO|DEBUG|WARN|ERROR)\]/

    # Clear the forwarded lines; the task keeps sending, so only check that
    # line 1 is gone.
    view |> element("button[phx-click=clear_logs]") |> render_click()
    refute render(view) =~ "(line 1)"
  end
end
