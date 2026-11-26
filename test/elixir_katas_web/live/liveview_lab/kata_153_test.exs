defmodule ElixirKatasWeb.LiveviewLab.Kata153Test do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/153-js-hooks-commands"

  test "renders the hook elements", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    for {id, hook} <- [
          {"kata153-copy-btn", "Clipboard"},
          {"kata153-local-time", "LocalTime"},
          {"kata153-key-listener", "KeyListener"},
          {"kata153-confetti-target", "ConfettiReceiver"}
        ] do
      assert has_element?(view, "##{id}[phx-hook=#{hook}]")
    end

    assert html =~ ~s(data-clipboard-text="Hello from LiveView! Copy me.")
    refute html =~ "Server Event Log"
  end

  test "JS.push targets the component", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Chained: push + toggle + transition") |> render_click()
    assert html =~ "Server Event Log"
    assert html =~ "server_ping received"
  end

  test "an event pushed by the KeyListener hook reaches the component", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    # pushEvent goes to the host LiveView, which forwards it to the kata.
    view |> element("#kata153-key-listener") |> render_hook("key_pressed", %{"key" => "Enter"})

    assert eventually(view, &(&1 =~ "Key pressed: Enter"))
  end

  test "push_event sends confetti to the client", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", ~s(Push "confetti" event to client)) |> render_click()

    assert_push_event(view, "confetti", %{message: "Party time! 🎉", timestamp: ts})
    assert is_integer(ts)
    assert html =~ "Pushed confetti event to client"
  end

  defp eventually(view, fun, tries \\ 50) do
    cond do
      fun.(render(view)) -> true
      tries == 0 -> false
      true -> Process.sleep(10) && eventually(view, fun, tries - 1)
    end
  end
end
