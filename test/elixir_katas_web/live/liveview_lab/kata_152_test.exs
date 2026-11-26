defmodule ElixirKatasWeb.LiveviewLab.Kata152Test do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/152-pubsub-presence"

  test "the shared counter is broadcast to every connected view", %{conn: conn} do
    {:ok, view1, _html} = live(conn, @path)
    {:ok, view2, _html} = live(build_conn(), @path)

    view1 |> element("button[phx-click=increment]") |> render_click()
    view1 |> element("button[phx-click=increment]") |> render_click()
    view2 |> element("button[phx-click=decrement]") |> render_click()

    assert eventually(view1, &(count(&1) == 1))
    assert eventually(view2, &(count(&1) == 1))
  end

  test "switching tabs away and back keeps one subscription and one identity", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    user = user_id(html)

    for _ <- 1..2 do
      view |> element("button", "Description") |> render_click()
      view |> element("button", "Interactive") |> render_click()
    end

    assert user_id(render(view)) == user

    view |> element("button[phx-click=increment]") |> render_click()
    assert eventually(view, &(count(&1) == 1))

    # A duplicate subscription would deliver the broadcast twice.
    Process.sleep(50)
    assert count(render(view)) == 1
  end

  test "chat messages reach a second connected view", %{conn: conn} do
    {:ok, view1, _html} = live(conn, @path)
    {:ok, view2, _html} = live(build_conn(), @path)
    user1 = user_id(render(view1))

    view1 |> form("form[phx-submit=send_message]") |> render_submit(%{"message" => "hello lab"})

    assert eventually(view2, &(&1 =~ "hello lab" and &1 =~ "#{user1}:"))

    # Empty messages are ignored.
    view1 |> form("form[phx-submit=send_message]") |> render_submit(%{"message" => ""})
  end

  test "joins are broadcast and Presence reports leaves", %{conn: conn} do
    {:ok, watcher, _html} = live(conn, @path)
    {:ok, leaver, _html} = live(build_conn(), @path)
    watcher_id = user_id(render(watcher))
    leaver_id = user_id(render(leaver))

    assert eventually(watcher, &(&1 =~ watcher_id and &1 =~ "(you)"))
    assert eventually(watcher, &(&1 =~ leaver_id))

    # The kata has no terminate/2; Presence sees the host process exit.
    Process.flag(:trap_exit, true)
    ref = Process.monitor(leaver.pid)
    Process.exit(leaver.pid, :kill)
    assert_receive {:DOWN, ^ref, :process, _, _}

    assert eventually(watcher, &(not (&1 =~ leaver_id)))
  end

  defp user_id(html) do
    [id] =
      Regex.run(~r/<code class="badge badge-sm">(user-\d+)<\/code>/, html,
        capture: :all_but_first
      )

    id
  end

  defp count(html) do
    [n] = Regex.run(~r/min-w-\[3ch\][^>]*>\s*(-?\d+)\s*</, html, capture: :all_but_first)
    String.to_integer(n)
  end

  defp eventually(view, fun, tries \\ 100) do
    cond do
      fun.(render(view)) -> true
      tries == 0 -> false
      true -> Process.sleep(10) && eventually(view, fun, tries - 1)
    end
  end
end
