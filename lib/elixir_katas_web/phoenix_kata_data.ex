defmodule ElixirKatasWeb.PhoenixKataData do
  @moduledoc """
  Shared data module for Phoenix Katas sections, tags, and colors.
  Used by both the sidebar layout and the index page.
  """

  @tag_colors %{
    "routing" => "bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200",
    "controllers" => "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200",
    "templates" => "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200",
    "plugs" => "bg-rose-100 text-rose-800 dark:bg-rose-900 dark:text-rose-200",
    "ecto" => "bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200",
    "channels" => "bg-violet-100 text-violet-800 dark:bg-violet-900 dark:text-violet-200"
  }

  def all_tags, do: Map.keys(@tag_colors) |> Enum.sort()
  def tag_color(tag), do: Map.get(@tag_colors, tag, "bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-200")

  def sections do
    [
      %{title: "Section 0: Foundations", katas: [
        %{num: "00", slug: "00-phoenix-fundamentals", label: "00 - Phoenix Fundamentals", color: "bg-amber-500", tags: ["routing", "controllers", "plugs"], description: "What is Phoenix, MVC architecture, request lifecycle, project structure, Mix tasks, Plug & Conn"}
      ]}
    ]
  end
end
