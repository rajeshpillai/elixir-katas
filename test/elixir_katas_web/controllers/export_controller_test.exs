defmodule ElixirKatasWeb.ExportControllerTest do
  # Not async: one test changes application config.
  use ElixirKatasWeb.ConnCase, async: false

  @chrome ~w(google-chrome google-chrome-stable chromium chromium-browser chrome)
          |> Enum.find_value(&System.find_executable/1)

  @payload %{
    "title" => ~s(<iframe src="file:///etc/hostname"></iframe>),
    "body" => ~s(**Hi** <iframe src="file:///etc/hostname"></iframe>)
  }

  @tag skip: is_nil(@chrome) && "Chrome is not installed"
  test "POST /exports/pdf returns a PDF", %{conn: conn} do
    conn = post(conn, ~p"/exports/pdf", @payload)

    assert response_content_type(conn, :pdf) =~ "application/pdf"
    assert "%PDF" <> _ = response(conn, 200)
  end

  test "POST /exports/pdf redirects with an error when Chrome is missing", %{conn: conn} do
    previous = Application.get_env(:elixir_katas, :chrome_path)
    Application.put_env(:elixir_katas, :chrome_path, "/nonexistent/chrome")

    on_exit(fn ->
      if previous,
        do: Application.put_env(:elixir_katas, :chrome_path, previous),
        else: Application.delete_env(:elixir_katas, :chrome_path)
    end)

    # Point PATH lookups at nothing so no system Chrome is found either.
    path = System.get_env("PATH")
    System.put_env("PATH", "/nonexistent")
    on_exit(fn -> System.put_env("PATH", path) end)

    conn = post(conn, ~p"/exports/pdf", @payload)

    assert redirected_to(conn) == ~p"/liveview-katas/98-pdf"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "needs Google Chrome"
  end
end
