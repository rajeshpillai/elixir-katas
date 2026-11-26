defmodule ElixirKatasWeb.LiveviewLab.Kata144Test do
  @moduledoc "Interaction tests for kata 144 (Events & Bindings)."
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/144-events-bindings"

  test "click events are logged", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Events logged: 0"

    view |> element("button", "phx-click") |> render_click()
    html = view |> element("button", "Another click") |> render_click()

    assert html =~ "Button clicked"
    assert html =~ "Another button clicked"
    assert html =~ "Events logged: 2"
  end

  test "input change, focus, blur and submit are logged", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> element(~s|form[phx-change="log_change"]|)
    |> render_change(%{"demo_input" => "hello"})

    view |> element(~s|input[name="demo_input"]|) |> render_focus()
    view |> element(~s|input[name="demo_input"]|) |> render_blur()

    html =
      view
      |> element(~s|form[phx-submit="log_submit"]|)
      |> render_submit(%{"form_value" => "sent"})

    assert html =~ "value: &quot;hello&quot;"
    assert html =~ "Input gained focus"
    assert html =~ "Input lost focus"
    assert html =~ "Submitted: &quot;sent&quot;"
    assert html =~ "Events logged: 4"
  end

  test "clear empties the stream log", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("button", "phx-click") |> render_click()
    html = view |> element("button", "Clear") |> render_click()

    refute html =~ "Button clicked"
    assert html =~ "Events logged: 0"
  end

  test "debounce and throttle counters", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> element(~s|form[phx-change="debounce_changed"]|)
    |> render_change(%{"debounce_input" => "abc"})

    html =
      view
      |> element(~s|form[phx-change="throttle_changed"]|)
      |> render_change(%{"throttle_input" => "xyz"})

    assert html =~ ~r/badge-primary badge-sm font-mono">\s*1\s*</
    assert html =~ ~r/badge-secondary badge-sm font-mono">\s*1\s*</
    assert html =~ "<code class=\"text-xs\">abc</code>"
    assert html =~ "<code class=\"text-xs\">xyz</code>"

    html = view |> element("button", "Reset counters") |> render_click()
    assert html =~ ~r/badge-primary badge-sm font-mono">\s*0\s*</
    refute html =~ "<code class=\"text-xs\">abc</code>"
  end

  test "window keydown and the filtered Enter key", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> element(~s|[phx-window-keydown="keypress"]|)
      |> render_keydown(%{"key" => "q"})

    assert html =~ ~r/<kbd[^>]*>\s*q\s*<\/kbd>/
    assert html =~ "Press Enter..."

    html =
      view
      |> element(~s|[phx-window-keydown="special_key"]|)
      |> render_keydown(%{"key" => "Enter"})

    assert html =~ "Enter at "
    assert html =~ "Enter pressed (filtered)"
  end

  test "phx-value-* attributes arrive as params", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Blue / Medium") |> render_click()
    assert html =~ "Received: color=blue, size=medium, id=btn-2"
  end
end
