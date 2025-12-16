defmodule ElixirKatasWeb.PageController do
  use ElixirKatasWeb, :controller
  plug :put_layout, html: {ElixirKatasWeb.Layouts, :app}

  def home(conn, _params) do
    render(conn, :home)
  end
end
