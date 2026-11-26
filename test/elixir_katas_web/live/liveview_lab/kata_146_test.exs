defmodule ElixirKatasWeb.LiveviewLab.Kata146Test do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/146-function-components"

  test "renders cards with slots and the data table", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path)

    assert html =~ "Default Variant"
    assert html =~ "Primary Variant"
    assert html =~ "Warning Variant"
    assert html =~ "Learn More"
    assert html =~ "Year Created"
    assert html =~ "TypeScript"
  end

  test "global attributes pass through to the button", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#kata-146-ghost-btn[data-tip='I have a data-tip attribute']")
    # As upstream: the component's own class={...} comes first, so a
    # caller's class in @rest does not replace it.
    assert has_element?(view, "button.btn-secondary[phx-value-name=secondary]")
  end

  test "clicks passed through @rest reach the component", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    refute html =~ "Click Log"

    html = view |> element("#kata-146-ghost-btn") |> render_click()
    assert html =~ "Clicked: ghost button (via @rest pass-through)"

    html = view |> element("button", "Primary Button") |> render_click()
    assert html =~ "Clicked: primary button"
  end
end
