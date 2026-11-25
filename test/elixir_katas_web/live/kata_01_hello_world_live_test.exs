defmodule ElixirKatasWeb.Kata01HelloWorldLiveTest do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @kata_path "/liveview-katas/01-hello-world"

  test "renders hello world kata", %{conn: conn} do
    {:ok, view, html} = live(conn, @kata_path)

    assert html =~ "Kata 01: Hello World"
    assert html =~ "Description"

    # The interactive tab is shown first and renders the compiled kata.
    assert html =~ "Click me!"
    assert view |> element("button", "Click me!") |> render_click() =~ "You clicked me!!!"

    # Notes tab
    html = view |> element("button", "Description") |> render_click()
    assert html =~ "prose dark:prose-invert"

    # Source tab mounts the code editor hook
    html = view |> element("button", "Source Code") |> render_click()
    assert html =~ ~s(phx-hook="CodeEditor")
  end
end
