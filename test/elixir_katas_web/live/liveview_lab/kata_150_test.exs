defmodule ElixirKatasWeb.LiveviewLab.Kata150Test do
  @moduledoc "Interaction tests for kata 150 (Temporary Assigns & Pagination)."
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/150-temporary-assigns"

  # "Load More" goes through a message to the host LiveView, so the new page
  # shows up a little after the click.
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

  test "renders the first page and explains temporary assigns", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "temporary_assigns: [items: []]"
    assert html =~ "Page: 1"
    assert has_element?(view, "#lvlab-temp-stream-items #items-1")
    assert has_element?(view, "#items-20")
    refute has_element?(view, "#items-21")
  end

  test "appends items to a stream", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Append 10 items") |> render_click()
    assert html =~ "Items appended: 10"
    assert has_element?(view, "#lvlab-temp-append-items #append_items-1")
    assert has_element?(view, "#append_items-10")

    view |> element("button", "Append 10 items") |> render_click()
    assert render(view) =~ "Items appended: 20"
    assert has_element?(view, "#append_items-1")
    assert has_element?(view, "#append_items-20")
  end

  test "Load More streams in pages until the end of the data", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    for page <- 2..5 do
      html = view |> element("button", "Load More") |> render_click()
      assert html =~ "Loading..."

      eventually(fn -> render(view) =~ "Page: #{page}" end)
      assert has_element?(view, "#items-#{page * 20}")
    end

    # Earlier pages stay in the client-side stream.
    assert has_element?(view, "#items-1")
    assert render(view) =~ "All data loaded."
    refute has_element?(view, "button", "Load More")
  end
end
