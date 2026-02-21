defmodule ElixirKatasWeb.ElixirKatasIndexLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto py-8">
      <h1 class="text-3xl font-bold mb-4 text-gray-900 dark:text-white">
        Elixir Katas
      </h1>
      <p class="text-lg text-gray-600 dark:text-gray-300 mb-8">
        Master core Elixir from the ground up. Select a kata from the sidebar or the list below.
      </p>

      <%!-- Section 1: Types, Operators & Basics --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 1: Types, Operators & Basics
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="01. Type Explorer" description="Basic types: integer, float, string, atom, boolean, nil" path={~p"/elixir-katas/01-type-explorer"} />
        <.kata_card title="02. Arithmetic Lab" description="Operators: +, -, *, /, div, rem; float vs integer division" path={~p"/elixir-katas/02-arithmetic-lab"} />
        <.kata_card title="03. String Playground" description="Concatenation, interpolation, String module functions" path={~p"/elixir-katas/03-string-playground"} />
        <.kata_card title="04. Atoms & Booleans" description="Atoms, boolean operators (and/or vs &&/||), truthy/falsy" path={~p"/elixir-katas/04-atoms-booleans"} />
        <.kata_card title="05. Comparison & Ordering" description="==, ===, <, >, term ordering across types" path={~p"/elixir-katas/05-comparison"} />
        <.kata_card title="06. Tuples" description="{a, b}, elem/2, put_elem/3, {:ok, val}/{:error, reason}" path={~p"/elixir-katas/06-tuples"} />
        <.kata_card title="07. Lists" description="[head|tail], hd/tl, ++, --, prepend vs append performance" path={~p"/elixir-katas/07-lists"} />
        <.kata_card title="08. Maps & Keyword Lists" description="%{}, Map module, keyword lists, when to use each" path={~p"/elixir-katas/08-maps-keywords"} />
      </div>

      <%!-- Section 2: Pattern Matching --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 2: Pattern Matching
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="09. Match Operator" description="= is match not assignment, binding vs matching" path={~p"/elixir-katas/09-match-operator"} />
        <.kata_card title="10. Tuple Matching" description="{:ok, val}, {:error, reason} destructuring" path={~p"/elixir-katas/10-tuple-matching"} />
        <.kata_card title="11. List Matching" description="[h|t], fixed-length, nested matching" path={~p"/elixir-katas/11-list-matching"} />
        <.kata_card title="12. Map Matching" description="Partial map matching, nested extraction" path={~p"/elixir-katas/12-map-matching"} />
        <.kata_card title="13. Pin Operator" description="^ to match against existing bindings" path={~p"/elixir-katas/13-pin-operator"} />
        <.kata_card title="14. Multi-clause Matching" description="Multiple function clauses, first-match-wins" path={~p"/elixir-katas/14-multi-clause"} />
        <.kata_card title="15. Destructuring" description="Complex nested structures, chained extraction" path={~p"/elixir-katas/15-destructuring"} />
        <.kata_card title="16. Matching Challenges" description="Pattern matching mini-challenges with scoring" path={~p"/elixir-katas/16-matching-challenges"} />
      </div>

      <%!-- Section 3: Functions --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 3: Functions
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="17. Anonymous Functions" description="fn -> end, closures, .() calling" path={~p"/elixir-katas/17-anonymous-functions"} />
        <.kata_card title="18. Named Functions" description="def/defp, arity, defmodule" path={~p"/elixir-katas/18-named-functions"} />
        <.kata_card title="19. Guards" description="when clauses, allowed guard expressions" path={~p"/elixir-katas/19-guards"} />
        <.kata_card title="20. Default Arguments" description="\\\\ syntax, generated arities" path={~p"/elixir-katas/20-default-args"} />
        <.kata_card title="21. Capture Operator" description="&, &Module.fun/arity, &(&1 + 1) shorthand" path={~p"/elixir-katas/21-capture-operator"} />
        <.kata_card title="22. Recursion" description="Base case + recursive case, visual call stack" path={~p"/elixir-katas/22-recursion"} />
        <.kata_card title="23. Tail Recursion" description="Accumulators, stack depth comparison" path={~p"/elixir-katas/23-tail-recursion"} />
        <.kata_card title="24. Higher-Order Functions" description="Functions as values, composition" path={~p"/elixir-katas/24-higher-order"} />
      </div>

      <%!-- Section 4: Control Flow --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 4: Control Flow
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="25. Case Expressions" description="Pattern matching on values, guards in case" path={~p"/elixir-katas/25-case"} />
        <.kata_card title="26. Cond Expressions" description="Boolean conditions, first-true-wins" path={~p"/elixir-katas/26-cond"} />
        <.kata_card title="27. If/Unless" description="Simple conditionals, macros not special forms" path={~p"/elixir-katas/27-if-unless"} />
        <.kata_card title="28. With Expressions" description="Happy path chaining, else clauses" path={~p"/elixir-katas/28-with"} />
        <.kata_card title="29. Pipe Operator" description="|> pipelines, nested-to-piped refactoring" path={~p"/elixir-katas/29-pipe-operator"} />
        <.kata_card title="30. Comprehensions" description="for generators, filters, :into" path={~p"/elixir-katas/30-comprehensions"} />
        <.kata_card title="31. Try/Rescue" description="Error handling, let it crash philosophy" path={~p"/elixir-katas/31-try-rescue"} />
      </div>

      <%!-- Section 5: Enum & Stream --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 5: Enum & Stream
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="32. Enum Basics" description="map, filter, reduce, each" path={~p"/elixir-katas/32-enum-basics"} />
        <.kata_card title="33. Enum Transforms" description="sort, reverse, uniq, flat_map, zip, chunk_every" path={~p"/elixir-katas/33-enum-transforms"} />
        <.kata_card title="34. Enum Aggregates" description="count, sum, min/max, frequencies, group_by" path={~p"/elixir-katas/34-enum-aggregates"} />
        <.kata_card title="35. Enum Search" description="find, any?, all?, take_while, drop_while" path={~p"/elixir-katas/35-enum-search"} />
        <.kata_card title="36. Reduce Mastery" description="Step-through animation, implement map/filter with reduce" path={~p"/elixir-katas/36-reduce-mastery"} />
        <.kata_card title="37. MapSet" description="Set operations: union, intersection, difference" path={~p"/elixir-katas/37-mapset"} />
        <.kata_card title="38. Streams" description="Eager vs lazy, Stream.map/filter/take" path={~p"/elixir-katas/38-streams"} />
        <.kata_card title="39. Stream Generators" description="iterate, unfold, cycle, infinite streams" path={~p"/elixir-katas/39-stream-generators"} />
        <.kata_card title="40. Ranges & Slicing" description="1..10, step ranges, Enum.slice/take/drop" path={~p"/elixir-katas/40-ranges-slicing"} />
      </div>

      <%!-- Section 6: Strings, Binaries & Sigils --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 6: Strings, Binaries & Sigils
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="41. String Deep Dive" description="UTF-8 binaries, byte_size vs String.length, graphemes" path={~p"/elixir-katas/41-string-deep-dive"} />
        <.kata_card title="42. Charlists vs Strings" description="Single vs double quotes, conversion" path={~p"/elixir-katas/42-charlists"} />
        <.kata_card title="43. String Matching" description="Binary matching <<h::utf8, rest::binary>>" path={~p"/elixir-katas/43-string-matching"} />
        <.kata_card title="44. Regex" description="~r//, Regex.match?/run/scan/replace" path={~p"/elixir-katas/44-regex"} />
        <.kata_card title="45. Sigils" description="~s, ~w, ~D, ~T, ~r, uppercase vs lowercase" path={~p"/elixir-katas/45-sigils"} />
        <.kata_card title="46. Formatting" description="String.pad, IO.inspect options, number formatting" path={~p"/elixir-katas/46-formatting"} />
      </div>

      <%!-- Section 7: Structs, Protocols & Behaviours --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 7: Structs, Protocols & Behaviours
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="47. Structs" description="defstruct, @enforce_keys, update syntax" path={~p"/elixir-katas/47-structs"} />
        <.kata_card title="48. Struct Validation" description="Constructor patterns, new/1 returning tagged tuples" path={~p"/elixir-katas/48-struct-validation"} />
        <.kata_card title="49. Protocols" description="defprotocol/defimpl, dispatch on type" path={~p"/elixir-katas/49-protocols"} />
        <.kata_card title="50. Built-in Protocols" description="String.Chars, Inspect, Enumerable" path={~p"/elixir-katas/50-builtin-protocols"} />
        <.kata_card title="51. Behaviours" description="@callback, @behaviour, compile-time contracts" path={~p"/elixir-katas/51-behaviours"} />
        <.kata_card title="52. Polymorphism" description="Protocols vs behaviours vs pattern matching" path={~p"/elixir-katas/52-polymorphism"} />
        <.kata_card title="53. Module Attributes" description="@moduledoc, @doc, @spec, @type, constants" path={~p"/elixir-katas/53-module-attributes"} />
        <.kata_card title="54. Use & Import" description="import, alias, require, use, __using__ macro" path={~p"/elixir-katas/54-use-import"} />
      </div>

      <%!-- Section 8: Processes & Message Passing --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 8: Processes & Message Passing
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="55. Spawn & Processes" description="spawn/1, self(), process isolation, PIDs" path={~p"/elixir-katas/55-spawn"} />
        <.kata_card title="56. Send & Receive" description="Message passing, mailbox visualization" path={~p"/elixir-katas/56-send-receive"} />
        <.kata_card title="57. Process Links" description="spawn_link, bidirectional crash propagation" path={~p"/elixir-katas/57-process-links"} />
        <.kata_card title="58. Process Monitors" description="Process.monitor, :DOWN messages" path={~p"/elixir-katas/58-process-monitors"} />
        <.kata_card title="59. Process State Loop" description="Recursive receive loop (DIY GenServer)" path={~p"/elixir-katas/59-process-state"} />
        <.kata_card title="60. Trapping Exits" description="trap_exit flag, converting exits to messages" path={~p"/elixir-katas/60-trap-exits"} />
        <.kata_card title="61. Task Module" description="Task.async/await, async_stream, concurrency" path={~p"/elixir-katas/61-tasks"} />
        <.kata_card title="62. Agent" description="Simple state server, get/update/get_and_update" path={~p"/elixir-katas/62-agents"} />
      </div>

      <%!-- Section 9: GenServer & OTP --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 9: GenServer & OTP
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="63. GenServer Basics" description="init, handle_call, handle_cast, handle_info" path={~p"/elixir-katas/63-genserver-basics"} />
        <.kata_card title="64. Call vs Cast" description="Sync vs async, blocking behavior, timeouts" path={~p"/elixir-katas/64-call-vs-cast"} />
        <.kata_card title="65. GenServer State" description="Complex state, named processes, Registry" path={~p"/elixir-katas/65-genserver-state"} />
        <.kata_card title="66. Periodic Work" description="Process.send_after, timer patterns" path={~p"/elixir-katas/66-periodic-work"} />
        <.kata_card title="67. Supervisor Basics" description="Restart strategies: one_for_one, one_for_all" path={~p"/elixir-katas/67-supervisors"} />
        <.kata_card title="68. Dynamic Supervisors" description="DynamicSupervisor, start_child/terminate_child" path={~p"/elixir-katas/68-dynamic-supervisor"} />
        <.kata_card title="69. Supervision Trees" description="Nested supervisors, fault tolerance" path={~p"/elixir-katas/69-supervision-trees"} />
        <.kata_card title="70. Registry" description="Process lookup, :unique vs :duplicate, pub/sub" path={~p"/elixir-katas/70-registry"} />
        <.kata_card title="71. ETS Tables" description=":ets operations, table types, concurrent reads" path={~p"/elixir-katas/71-ets"} />
      </div>

      <%!-- Section 10: Advanced Patterns --%>
      <h2 class="text-xl font-bold text-emerald-700 dark:text-emerald-400 mb-4 mt-8 border-b border-emerald-200 dark:border-emerald-800 pb-2">
        Section 10: Advanced Patterns
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <.kata_card title="72. Quote & Unquote" description="AST representation, homoiconicity" path={~p"/elixir-katas/72-quote-unquote"} />
        <.kata_card title="73. Macros" description="defmacro, compile-time code generation" path={~p"/elixir-katas/73-macros"} />
        <.kata_card title="74. App Config" description="Application.get_env, runtime vs compile-time" path={~p"/elixir-katas/74-app-config"} />
        <.kata_card title="75. The Elixir Toolbox" description="Decision-tree quiz: choosing the right tool" path={~p"/elixir-katas/75-toolbox"} />
      </div>
    </div>
    """
  end
end
