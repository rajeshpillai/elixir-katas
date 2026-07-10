defmodule ElixirKatasWeb.Hooks.SkillzEngineBridge do
  import Phoenix.Component, only: [assign: 3]

  def on_mount(:default, _params, _session, socket) do
    if Phoenix.LiveView.connected?(socket) do
      conn_params = Phoenix.LiveView.get_connect_params(socket) || %{}
      se_api = Map.get(conn_params, "se_api")
      se_token = Map.get(conn_params, "se_token")
      se_path = Map.get(conn_params, "se_path")

      completed = ElixirKatasWeb.SkillzEngineBridge.fetch_completed_katas(se_api, se_token, se_path)

      socket =
        socket
        |> assign(:se_api, se_api)
        |> assign(:se_token, se_token)
        |> assign(:se_path, se_path)
        |> assign(:completed_katas, MapSet.new(completed))

      {:cont, socket}
    else
      socket =
        socket
        |> assign(:se_api, nil)
        |> assign(:se_token, nil)
        |> assign(:se_path, nil)
        |> assign(:completed_katas, MapSet.new())

      {:cont, socket}
    end
  end
end
