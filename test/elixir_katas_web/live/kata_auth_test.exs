defmodule ElixirKatasWeb.KataAuthTest do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirKatas.AccountsFixtures

  alias ElixirKatas.Katas

  @kata_path "/liveview-katas/01-hello-world"
  @kata_name "Kata01"
  @source_path "lib/elixir_katas_web/live/kata_01_hello_world_live.ex"

  setup do
    %{user: user_fixture()}
  end

  test "guest sees read-only mode and cannot run code", %{conn: conn} do
    {:ok, view, html} = live(conn, @kata_path)

    assert html =~ "Read Only"

    html = view |> element("button", "Source Code") |> render_click()
    assert html =~ ~s(data-read-only="true")

    # Bypass the UI and push the event directly, as a malicious client would.
    html = render_hook(view, "save_source", %{"source" => "raise \"pwned\""})
    assert html =~ "You must be logged in to edit."
    refute html =~ "Compiling..."
  end

  test "user can edit and the edit is saved", %{conn: conn, user: user} do
    {:ok, view, html} = conn |> log_in_user(user) |> live(@kata_path)

    refute html =~ "Read Only"

    new_source = File.read!(@source_path) <> "\n# User Edit\n"
    render_hook(view, "save_source", %{"source" => new_source})

    assert_eventually(fn -> render(view) =~ "Saved!" end)
    assert Katas.get_user_kata(user.id, @kata_name).source_code == new_source
  end

  test "revert deletes the user's saved version", %{conn: conn, user: user} do
    Katas.save_user_kata(user.id, @kata_name, File.read!(@source_path) <> "\n# Old edit\n")

    {:ok, view, _html} = conn |> log_in_user(user) |> live(@kata_path)

    render_hook(view, "revert", %{})

    refute Katas.get_user_kata(user.id, @kata_name)
    assert render(view) =~ "Reverted to original version!"
  end

  defp assert_eventually(fun, attempts \\ 50) do
    cond do
      fun.() ->
        :ok

      attempts == 0 ->
        flunk("condition was not met in time")

      true ->
        Process.sleep(20)
        assert_eventually(fun, attempts - 1)
    end
  end
end
