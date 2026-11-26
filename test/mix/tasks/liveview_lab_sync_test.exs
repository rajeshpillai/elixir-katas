defmodule Mix.Tasks.LiveviewLab.SyncTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.LiveviewLab.Sync

  describe "rewrite_note/2" do
    @note """
    # Lesson 10: Temporary Assigns & Pagination

    **Source file:** `lib/liveview_lab_web/live/lesson10_temp_assigns_live.ex`

    Hooks are registered in `app.js` (see Lesson 6 for details).
    Lesson 42 is not part of the tutorial.
    """

    test "renames the title and adds the origin note" do
      out = Sync.rewrite_note(@note, 10)

      assert out =~ ~r/\A# Kata 150: Temporary Assigns & Pagination\n\n> Ported from lesson 10 of/
    end

    test "points source paths at the kata files" do
      out = Sync.rewrite_note(@note, 10)

      assert out =~ "`lib/elixir_katas_web/live/kata_150_temporary_assigns_live.ex`"
      refute out =~ "liveview_lab_web"
    end

    test "maps lesson cross-references to kata numbers, only for lessons 1-13" do
      out = Sync.rewrite_note(@note, 10)

      assert out =~ "see Kata 146 for details"
      assert out =~ "Lesson 42 is not part"
    end

    test "rewrites the lesson 11 component paths" do
      note = "- `lib/liveview_lab_web/components/counter_component.ex`"

      assert Sync.rewrite_note(note, 11) =~
               "`lib/elixir_katas_web/components/liveview_lab/counter_component.ex`"
    end
  end

  describe "rename_modules/1" do
    test "moves tutorial modules into the ElixirKatas namespaces" do
      code = """
      defmodule LiveviewLabWeb.Components.CounterComponent do
        use LiveviewLabWeb, :live_component
        def go, do: Phoenix.PubSub.broadcast(LiveviewLab.PubSub, "t", :x)
      end
      """

      out = Sync.rename_modules(code)

      assert out =~ "defmodule ElixirKatasWeb.LiveviewLab.CounterComponent do"
      assert out =~ "use ElixirKatasWeb, :live_component"
      assert out =~ "ElixirKatas.PubSub"
      refute out =~ "LiveviewLab.PubSub"
    end
  end

  test "the synced notes in the repo match a fresh rewrite of upstream" do
    checkout = "_build/liveview_lab_upstream"

    if File.dir?(checkout) do
      upstream = File.read!(Path.join(checkout, "notes/01-liveview-architecture.md"))
      assert File.read!("notes/kata_141_architecture_notes.md") == Sync.rewrite_note(upstream, 1)
    end
  end
end
