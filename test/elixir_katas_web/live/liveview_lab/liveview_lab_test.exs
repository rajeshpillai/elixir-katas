defmodule ElixirKatasWeb.LiveviewLabTest do
  @moduledoc """
  Smoke tests for "Section 11: LiveView Lab" (katas 141-153), ported from
  phoenix-liveview-tutorial. Each kata must mount, compile and render its demo.
  Per-kata interaction tests live next to this file.
  """
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @section Enum.find(ElixirKatasWeb.LiveviewKataData.sections(), &(&1.title == "Section 11: LiveView Lab"))

  test "the section lists katas 141 to 153" do
    assert Enum.map(@section.katas, & &1.num) == Enum.map(141..153, &Integer.to_string/1)
  end

  for kata <- @section.katas do
    @kata kata

    test "kata #{kata.num} mounts and renders its demo", %{conn: conn} do
      {:ok, view, html} = live(conn, "/liveview-katas/#{@kata.slug}")

      assert html =~ "Kata #{@kata.num}:"
      refute html =~ "Waiting for successful compilation"
      refute html =~ "compilation failed"

      # The notes tab renders the synced notes file.
      notes = view |> element("button", "Description") |> render_click()
      assert notes =~ "Kata #{@kata.num}:"
      refute notes =~ "Notes not found."
    end
  end

  test "kata 141 events reach the component", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/liveview-katas/141-architecture")

    html = view |> element("button", "Count: 0") |> render_click()
    assert html =~ "Count: 1"

    html = view |> element("button", "Add 1,000 Items") |> render_click()
    assert html =~ "1000"
  end
end
