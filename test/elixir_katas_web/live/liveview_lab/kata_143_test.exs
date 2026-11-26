defmodule ElixirKatasWeb.LiveviewLab.Kata143Test do
  @moduledoc "Interaction tests for kata 143 (Assigns & Reactivity)."
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/143-assigns-reactivity"

  defp reactive_form(view), do: element(view, ~s|form[phx-change="update_reactive"]|)
  defp profile_form(view), do: element(view, ~s|form[phx-submit="save"]|)

  test "renders the initial reactive state", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path)

    assert html =~ "Hello, World!"
    assert html =~ "#3b82f6"
  end

  test "the reactive explorer updates each card", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> reactive_form()
      |> render_change(%{"_target" => ["name"], "name" => "Elixir"})

    assert html =~ "Hello, Elixir!"

    html =
      view
      |> reactive_form()
      |> render_change(%{"_target" => ["color"], "color" => "#ff0000"})

    assert html =~ "background-color: #ff0000"

    html =
      view
      |> reactive_form()
      |> render_change(%{"_target" => ["count"], "count" => "3"})

    assert html =~ "* * *"
    refute html =~ "* * * *"
  end

  test "validates the profile form on change", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> profile_form()
      |> render_change(%{
        "_target" => ["profile", "email"],
        "profile" => %{"username" => "ab", "email" => "nope", "bio" => "hi"}
      })

    assert html =~ "must be at least 3 characters"
    assert html =~ "must contain @"
    assert html =~ "Bio: 2/200 characters"
  end

  test "saving an invalid profile shows errors", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> profile_form()
      |> render_submit(%{"profile" => %{"username" => "", "email" => "", "bio" => ""}})

    assert html =~ "can&#39;t be blank"
    refute html =~ "Profile saved successfully!"
  end

  test "saving a valid profile shows success", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> profile_form()
      |> render_submit(%{
        "profile" => %{"username" => "jose", "email" => "jose@example.com", "bio" => "Hi"}
      })

    assert html =~ "Profile saved successfully!"
    assert html =~ "jose@example.com"
  end
end
