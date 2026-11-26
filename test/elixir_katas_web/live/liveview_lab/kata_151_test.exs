defmodule ElixirKatasWeb.LiveviewLab.Kata151Test do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/151-live-components"
  @alpha "div.grid-cols-3 > div:nth-child(1)"
  @beta "div.grid-cols-3 > div:nth-child(2)"
  @first_card "div.grid.gap-3 > div:nth-child(1)"

  test "each nested CounterComponent keeps its own state", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#{@alpha} button[phx-click=inc]") |> render_click()
    view |> element("#{@alpha} button[phx-click=inc]") |> render_click()
    view |> element("#{@beta} button[phx-click=dec]") |> render_click()

    assert view |> element(@alpha) |> render() =~ ~r/>\s*2\s*</
    assert view |> element(@beta) |> render() =~ ~r/>\s*-1\s*</
  end

  test "the parent resets a counter with send_update", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#{@alpha} button[phx-click=inc]") |> render_click()
    view |> element("#{@beta} button[phx-click=inc]") |> render_click()

    html = view |> element("button", "Reset Alpha (via send_update)") |> render_click()
    assert html =~ "Last event: Parent sent reset to counter-a"

    assert view |> element(@alpha) |> render() =~ ~r/>\s*0\s*</
    assert view |> element(@beta) |> render() =~ ~r/>\s*1\s*</
  end

  test "saving a card notifies the parent through the host LiveView", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#{@first_card} button[phx-click=edit]") |> render_click()

    html =
      view
      |> form("#{@first_card} form[phx-submit=save]")
      |> render_submit(%{"title" => "Elixir 1.19", "content" => "Still functional"})

    assert html =~ "Elixir 1.19"
    assert html =~ "Still functional"

    # {:card_saved, ...} goes to the host LiveView, which forwards it to the kata.
    assert eventually(view, &(&1 =~ "Last event: Card card-1 saved: &quot;Elixir 1.19&quot;"))
  end

  defp eventually(view, fun, tries \\ 50) do
    cond do
      fun.(render(view)) -> true
      tries == 0 -> false
      true -> Process.sleep(10) && eventually(view, fun, tries - 1)
    end
  end
end
