defmodule ElixirKatasWeb.LiveviewLab.Kata145Test do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/145-navigation-routing"

  test "renders the list view and first page sorted by name", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path)

    assert html =~ "Patch vs Navigate"
    assert html =~ "Current view:"
    assert html =~ "List row one"
    assert html =~ "Page 1 of 4"
    # First five languages by name
    assert html =~ "Clojure"
    refute html =~ "Zig"
  end

  test "patch links change the view in the same process", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    pid_before = render(view) |> pid_text()

    html = view |> element("a", "?view=grid") |> render_click()
    assert_patch(view, @path <> "?view=grid")
    assert html =~ "Grid A"
    refute html =~ "List row one"

    html = view |> element("a", "?view=table") |> render_click()
    assert_patch(view, @path <> "?view=table")
    assert html =~ "Col 1"
    assert pid_text(html) == pid_before
  end

  test "sort and pagination are driven by the URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("a.btn", "Year") |> render_click()
    assert_patch(view, @path <> "?sort=year&page=1")
    assert html =~ "sort=<code>year</code>"
    # Oldest first
    assert html =~ "Erlang"

    html = view |> element(".join a", "4") |> render_click()
    assert_patch(view, @path <> "?sort=year&page=4")
    assert html =~ "Page 4 of 4"
    assert html =~ "Zig"
  end

  test "invalid params fall back to defaults", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path <> "?page=abc&sort=bogus")
    assert html =~ "Page 1 of 4"

    {:ok, _view, html} = live(conn, @path <> "?page=99")
    assert html =~ "Page 4 of 4"
  end

  test "deep link renders the requested state", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path <> "?view=table&sort=typing&page=2")
    assert html =~ "Col 1"
    assert html =~ "Page 2 of 4"
    assert html =~ "sort=<code>typing</code>"
  end

  defp pid_text(html) do
    [pid] = Regex.run(~r/#PID&lt;[\d.]+&gt;/, html)
    pid
  end
end
