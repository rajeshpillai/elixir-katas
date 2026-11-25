defmodule ElixirKatasWeb.PageControllerTest do
  use ElixirKatasWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Master Elixir"
  end
end
