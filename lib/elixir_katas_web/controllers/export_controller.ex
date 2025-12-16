defmodule ElixirKatasWeb.ExportController do
  use ElixirKatasWeb, :controller
  alias ElixirKatas.CSV.MyParser

  def csv(conn, _params) do
    # Sample data
    headers = ["ID", "Name", "Role", "Joined Date"]
    data = [
      [1, "Alice Smith", "Engineer", "2024-01-15"],
      [2, "Bob Jones", "Designer", "2024-02-01"],
      [3, "Charlie Brown", "Manager", "2024-03-10"],
      [4, "Dana White", "Director", "2023-11-20"],
      [5, "Evan Green", "Developer", "2024-01-05"]
    ]

    csv_content = 
      [headers | data]
      |> MyParser.dump_to_iodata()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"users_export.csv\"")
    |> send_resp(200, csv_content)
  end
end
