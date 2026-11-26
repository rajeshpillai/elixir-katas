defmodule ElixirKatasWeb.LiveviewLab.Kata148Test do
  @moduledoc "Interaction tests for kata 148 (Streams & Async)."
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/148-streams-async"

  # The chunk loop sends messages through the host LiveView, so its effects
  # show up a little after the click that started it.
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

  test "assign_async loads the slow data and reload starts it again", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Loading slow data..."

    html = render_async(view, 3000)
    assert html =~ "Async-loaded item 1"
    assert html =~ "Async-loaded item 5"
    refute html =~ "Loading slow data..."

    html = view |> element("button", "Reload (triggers async again)") |> render_click()
    assert html =~ "Loading slow data..."
    refute html =~ "Async-loaded item 1"

    assert render_async(view, 3000) =~ "Async-loaded item 1"
  end

  test "messages are stream-inserted, deleted, batched and reset", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> form("form[phx-submit=add_message]", %{body: "Hello stream"})
      |> render_submit()

    assert html =~ "Hello stream"
    assert html =~ "Messages sent: 1"
    assert has_element?(view, "#lvlab-streams-messages #messages-1")

    # An empty message is ignored.
    view |> form("form[phx-submit=add_message]", %{body: ""}) |> render_submit()
    assert render(view) =~ "Messages sent: 1"

    view |> element("#messages-1 button") |> render_click()
    refute has_element?(view, "#messages-1")

    html = view |> element("button", "Add 100 items") |> render_click()
    assert html =~ "Messages sent: 101"
    assert has_element?(view, "#messages-2", "Batch item #2")
    assert has_element?(view, "#messages-101", "Batch item #101")

    view |> element("button", "Reset stream") |> render_click()
    refute has_element?(view, "#messages-2")
    refute has_element?(view, "#messages-101")
  end

  test "chunked loading streams 1,000 items in waves", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Load 1,000 items (chunked)") |> render_click()
    assert html =~ "50 / 1000 items loaded"
    assert has_element?(view, "#lvlab-streams-chunked-items #chunked_items-c-1")

    eventually(fn -> render(view) =~ "1000 / 1000 items loaded" end)
    assert has_element?(view, "#chunked_items-c-1000", "Chunked item #1000")

    html = view |> element("button[phx-click=reset_chunked]") |> render_click()
    refute html =~ "items loaded"
    refute has_element?(view, "#chunked_items-c-1")
  end
end
