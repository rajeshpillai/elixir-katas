defmodule Mix.Tasks.LiveviewLab.Sync do
  @shortdoc "Syncs the LiveView Lab katas (141-153) from phoenix-liveview-tutorial"

  @moduledoc """
  Keeps the "Section 11: LiveView Lab" katas in step with
  https://github.com/rajeshpillai/phoenix-liveview-tutorial.

      mix liveview_lab.sync                 # report changes and update notes + components
      mix liveview_lab.sync --check         # report only, write nothing (exit 1 if behind)
      mix liveview_lab.sync --all           # rewrite every note and component, not just changed ones
      mix liveview_lab.sync --mark-synced   # after re-porting lesson code, record upstream HEAD
      mix liveview_lab.sync --ref <sha>     # compare against a commit/branch other than main

  What is synced how:

    * Notes (`notes/NN-*.md`) are copied to `notes/kata_1NN_*_notes.md` with a
      fixed set of rewrites (titles, lesson numbers, source paths, module names).
    * The lesson 11 helper components are copied with their module names renamed.
    * Lesson LiveViews are NOT copied. Each one is ported by hand into a
      LiveComponent kata (see docs/liveview_lab_sync.md), so the task lists the
      lessons whose code changed and which kata file to update.
    * Changes to `assets/js/app.js` are reported, because the lesson hooks live
      in `assets/js/hooks/liveview_lab.js` here.

  The last synced upstream commit is stored in `priv/liveview_lab_sync.json`.
  Hand edits to the synced notes and components are overwritten on the next
  sync; make content changes upstream instead.
  """
  use Mix.Task

  @repo "https://github.com/rajeshpillai/phoenix-liveview-tutorial.git"
  @state_file "priv/liveview_lab_sync.json"
  @checkout "_build/liveview_lab_upstream"

  # {lesson number, upstream LiveView, upstream notes, kata file base name}
  @lessons [
    {1, "lesson1_architecture_live.ex", "01-liveview-architecture.md", "kata_141_architecture"},
    {2, "lesson2_lifecycle_live.ex", "02-lifecycle-callbacks.md", "kata_142_lifecycle"},
    {3, "lesson3_assigns_reactivity_live.ex", "03-assigns-and-reactivity.md",
     "kata_143_assigns_reactivity"},
    {4, "lesson4_events_live.ex", "04-events-and-bindings.md", "kata_144_events_bindings"},
    {5, "lesson5_navigation_live.ex", "05-navigation-and-routing.md",
     "kata_145_navigation_routing"},
    {6, "lesson6_function_components_live.ex", "06-function-components.md",
     "kata_146_function_components"},
    {7, "lesson7_error_handling_live.ex", "07-error-handling-flash-uploads.md",
     "kata_147_errors_flash_uploads"},
    {8, "lesson8_streams_live.ex", "08-streams-and-async.md", "kata_148_streams_async"},
    {9, "lesson9_streaming_live.ex", "09-real-time-streaming.md", "kata_149_realtime_streaming"},
    {10, "lesson10_temp_assigns_live.ex", "10-temporary-assigns-and-pagination.md",
     "kata_150_temporary_assigns"},
    {11, "lesson11_components_live.ex", "11-livecomponents-deep-dive.md",
     "kata_151_live_components"},
    {12, "lesson12_pubsub_live.ex", "12-pubsub-and-presence.md", "kata_152_pubsub_presence"},
    {13, "lesson13_js_hooks_live.ex", "13-js-hooks-and-commands.md", "kata_153_js_hooks_commands"}
  ]

  @components [
    {"lib/liveview_lab_web/components/counter_component.ex",
     "lib/elixir_katas_web/components/liveview_lab/counter_component.ex"},
    {"lib/liveview_lab_web/components/editable_card_component.ex",
     "lib/elixir_katas_web/components/liveview_lab/editable_card_component.ex"}
  ]

  @hooks_source "assets/js/app.js"

  @impl Mix.Task
  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        strict: [check: :boolean, all: :boolean, mark_synced: :boolean, ref: :string]
      )

    ref = opts[:ref] || "origin/main"
    head = fetch_upstream(ref)
    last = read_state()["commit"]
    changed = changed_files(last, head, opts[:all])

    Mix.shell().info(
      "Upstream #{short(head)}; last synced #{if last, do: short(last), else: "never"}."
    )

    notes =
      for {n, _, note, base} <- @lessons, changed?(changed, note_path(note)), do: {n, note, base}

    comps = for {src, dst} <- @components, changed?(changed, src), do: {src, dst}

    lessons =
      for {n, file, _, base} <- @lessons,
          changed?(changed, lesson_path(file)),
          do: {n, file, base}

    hooks_changed? = changed?(changed, @hooks_source)

    report(notes, comps, lessons, hooks_changed?)

    cond do
      opts[:check] ->
        if notes != [] or comps != [] or lessons != [] or hooks_changed? do
          Mix.raise("LiveView Lab katas are behind upstream #{short(head)}.")
        end

      true ->
        Enum.each(notes, fn {n, note, base} -> write_note(n, note, base) end)
        Enum.each(comps, fn {src, dst} -> write_component(src, dst) end)

        cond do
          opts[:mark_synced] ->
            write_state(head)
            Mix.shell().info("Recorded #{short(head)} as synced.")

          lessons == [] and not hooks_changed? ->
            write_state(head)
            Mix.shell().info("Up to date with #{short(head)}.")

          true ->
            Mix.shell().info(
              "Re-port the lessons listed above, then run `mix liveview_lab.sync --mark-synced`."
            )
        end
    end
  end

  # -- Upstream ---------------------------------------------------------------

  defp fetch_upstream(ref) do
    if File.dir?(Path.join(@checkout, ".git")) do
      git!(["fetch", "--quiet", "origin"])
    else
      File.mkdir_p!(Path.dirname(@checkout))
      {_, 0} = System.cmd("git", ["clone", "--quiet", @repo, @checkout], stderr_to_stdout: true)
    end

    git!(["checkout", "--quiet", "--detach", ref])
    git!(["rev-parse", "HEAD"]) |> String.trim()
  end

  defp changed_files(_last, _head, true), do: :all
  defp changed_files(nil, _head, _), do: :all

  defp changed_files(last, head, _) do
    git!(["diff", "--name-only", last, head]) |> String.split("\n", trim: true)
  end

  defp changed?(:all, _path), do: true
  defp changed?(files, path), do: path in files

  defp git!(args) do
    case System.cmd("git", ["-C", @checkout | args], stderr_to_stdout: true) do
      {out, 0} -> out
      {out, _} -> Mix.raise("git #{Enum.join(args, " ")} failed:\n#{out}")
    end
  end

  defp upstream(path), do: File.read!(Path.join(@checkout, path))
  defp note_path(note), do: "notes/" <> note
  defp lesson_path(file), do: "lib/liveview_lab_web/live/" <> file
  defp short(sha), do: String.slice(sha, 0, 7)

  # -- Writers ----------------------------------------------------------------

  defp write_note(n, note, base) do
    content =
      note_path(note)
      |> upstream()
      |> rewrite_note(n)

    path = "notes/#{base}_notes.md"
    File.write!(path, content)
    Mix.shell().info("  wrote #{path}")
  end

  @doc false
  def rewrite_note(content, n) do
    lesson_files = Map.new(@lessons, fn {_, file, _, b} -> {lesson_path(file), kata_path(b)} end)
    component_files = Map.new(@components)

    content
    |> String.replace(~r/^# Lesson #{n}:/m, "# Kata #{140 + n}:", global: false)
    |> String.replace(~r/^(# Kata #{140 + n}:[^\n]*\n)/, "\\1\n" <> origin_note(n), global: false)
    |> replace_paths(lesson_files)
    |> replace_paths(component_files)
    |> String.replace(~r/\bLesson (\d+)\b/, fn match ->
      [_, num] = Regex.run(~r/(\d+)/, match)
      num = String.to_integer(num)
      if num in 1..13, do: "Kata #{140 + num}", else: match
    end)
    |> rename_modules()
  end

  defp origin_note(n) do
    "> Ported from lesson #{n} of [phoenix-liveview-tutorial](https://github.com/rajeshpillai/phoenix-liveview-tutorial). " <>
      "There the demo is a standalone LiveView; here it runs as a LiveComponent inside the kata page, " <>
      "so the source differs slightly from the snippets below.\n"
  end

  defp replace_paths(text, mapping) do
    Enum.reduce(mapping, text, fn {from, to}, acc -> String.replace(acc, from, to) end)
  end

  defp write_component(src, dst) do
    File.mkdir_p!(Path.dirname(dst))
    File.write!(dst, src |> upstream() |> rename_modules())
    Mix.shell().info("  wrote #{dst}")
  end

  @doc false
  def rename_modules(text) do
    text
    |> String.replace("LiveviewLabWeb.Components.", "ElixirKatasWeb.LiveviewLab.")
    |> String.replace("LiveviewLabWeb", "ElixirKatasWeb")
    |> String.replace("LiveviewLab.PubSub", "ElixirKatas.PubSub")
  end

  defp kata_path(base), do: "lib/elixir_katas_web/live/#{base}_live.ex"

  # -- Reporting and state ----------------------------------------------------

  defp report(notes, comps, lessons, hooks_changed?) do
    shell = Mix.shell()

    if notes != [], do: shell.info("Notes to update: #{Enum.map_join(notes, ", ", &elem(&1, 1))}")

    if comps != [],
      do: shell.info("Components to update: #{Enum.map_join(comps, ", ", &elem(&1, 1))}")

    for {n, file, base} <- lessons do
      shell.info("Lesson #{n} code changed (#{file}) -> re-port into #{kata_path(base)}")
    end

    if hooks_changed?,
      do: shell.info("#{@hooks_source} changed -> check assets/js/hooks/liveview_lab.js")
  end

  defp read_state do
    case File.read(@state_file) do
      {:ok, json} -> Jason.decode!(json)
      {:error, _} -> %{}
    end
  end

  defp write_state(commit) do
    File.mkdir_p!(Path.dirname(@state_file))

    File.write!(
      @state_file,
      Jason.encode!(%{repo: @repo, commit: commit}, pretty: true) <> "\n"
    )
  end
end
