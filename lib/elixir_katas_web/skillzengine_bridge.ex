defmodule ElixirKatasWeb.SkillzEngineBridge do
  require Logger

  @doc """
  Fetches the list of completed kata slugs from the parent SkillzEngine API.
  """
  def fetch_completed_katas(api, token, path) do
    if api && token && path do
      api_clean = String.replace_suffix(api, "/", "")
      url = "#{api_clean}/api/learning/progress"

      case Req.get(url, headers: [{"authorization", "Bearer #{token}"}], params: [pathId: path]) do
        {:ok, %Req.Response{status: 200, body: %{"success" => true, "progress" => %{"completed_katas" => completed}}}} ->
          Logger.info("[SkillzEngineBridge] Fetched #{length(completed)} completed katas.")
          completed

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("[SkillzEngineBridge] Failed to fetch progress: HTTP #{status} - #{inspect(body)}")
          []

        {:error, exception} ->
          Logger.error("[SkillzEngineBridge] Network error fetching progress: #{inspect(exception)}")
          []
      end
    else
      []
    end
  end

  @doc """
  Notifies the parent SkillzEngine API that a kata has been completed.
  """
  def notify_completion(api, token, path, kata_id) do
    if api && token && path && kata_id do
      api_clean = String.replace_suffix(api, "/", "")
      url = "#{api_clean}/api/learning/progress"
      body = %{pathId: path, kataId: kata_id}

      case Req.post(url, json: body, headers: [{"authorization", "Bearer #{token}"}]) do
        {:ok, %Req.Response{status: status, body: body}} when status in 200..299 ->
          Logger.info("[SkillzEngineBridge] Successfully notified completion for #{kata_id}.")
          {:ok, body}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("[SkillzEngineBridge] Failed to notify completion: HTTP #{status} - #{inspect(body)}")
          {:error, {:http_error, status, body}}

        {:error, exception} ->
          Logger.error("[SkillzEngineBridge] Network error notifying completion: #{inspect(exception)}")
          {:error, exception}
      end
    else
      {:error, :missing_parameters}
    end
  end

  @doc """
  Handles the complete_kata event by notifying parent and updating LiveView state.
  """
  def handle_complete_kata_event(socket) do
    se_api = Map.get(socket.assigns, :se_api)
    se_token = Map.get(socket.assigns, :se_token)
    se_path = Map.get(socket.assigns, :se_path)
    kata_slug = Map.get(socket.assigns, :kata_slug)

    if se_api && se_token && se_path && kata_slug do
      # Async post completion to parent API
      notify_completion(se_api, se_token, se_path, kata_slug)
    end

    if kata_slug do
      # Push event to client
      socket = Phoenix.LiveView.push_event(socket, "kata_completed", %{kata_id: kata_slug})

      # Update local assigns
      completed_katas = Map.get(socket.assigns, :completed_katas, MapSet.new())
      completed_katas = MapSet.put(completed_katas, kata_slug)
      Phoenix.Component.assign(socket, :completed_katas, completed_katas)
    else
      socket
    end
  end

  @doc """
  Resolves the canonical slug of a kata based on its ID and section type.
  """
  def get_slug(kata_id, section_type) do
    sections =
      case section_type do
        "Elixir" -> ElixirKatasWeb.ElixirKataData.sections()
        "Phoenix" -> ElixirKatasWeb.PhoenixKataData.sections()
        "Phoenix API" -> ElixirKatasWeb.PhoenixApiKataData.sections()
        "LiveView" -> ElixirKatasWeb.LiveviewKataData.sections()
      end

    kata = Enum.find(Enum.flat_map(sections, & &1.katas), & &1.num == kata_id)
    if kata, do: kata.slug, else: nil
  end
end
