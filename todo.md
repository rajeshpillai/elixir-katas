# Elixir Katas — Core Elixir Curriculum

## Section 1: Types, Operators & Basics (01-08)
- [x] **01. Type Explorer** - Basic types: integer, float, string, atom, boolean, nil
- [x] **02. Arithmetic Lab** - Operators: +, -, *, /, div, rem; float vs integer division
- [x] **03. String Playground** - Concatenation, interpolation, String module functions
- [x] **04. Atoms & Booleans** - Atoms, boolean operators (and/or vs &&/||), truthy/falsy
- [x] **05. Comparison & Ordering** - ==, ===, <, >, term ordering across types
- [x] **06. Tuples** - {a, b}, elem/2, put_elem/3, {:ok, val}/{:error, reason}
- [x] **07. Lists** - [head|tail], hd/tl, ++, --, prepend vs append performance
- [x] **08. Maps & Keyword Lists** - %{}, Map module, keyword lists, when to use each

## Section 2: Pattern Matching (09-16)
- [ ] **09. Match Operator** - = is match not assignment, binding vs matching
- [ ] **10. Tuple Matching** - {:ok, val}, {:error, reason} destructuring
- [ ] **11. List Matching** - [h|t], fixed-length, nested matching
- [ ] **12. Map Matching** - Partial map matching, nested extraction
- [ ] **13. Pin Operator** - ^ to match against existing bindings
- [ ] **14. Multi-clause Matching** - Multiple function clauses, first-match-wins
- [ ] **15. Destructuring** - Complex nested structures, chained extraction
- [ ] **16. Matching Challenges** - Pattern matching mini-challenges with scoring

## Section 3: Functions (17-24)
- [ ] **17. Anonymous Functions** - fn -> end, closures, .() calling
- [ ] **18. Named Functions** - def/defp, arity, defmodule
- [ ] **19. Guards** - when clauses, allowed guard expressions
- [ ] **20. Default Arguments** - \\\\ syntax, generated arities
- [ ] **21. Capture Operator** - &, &Module.fun/arity, &(&1 + 1) shorthand
- [ ] **22. Recursion** - Base case + recursive case, visual call stack
- [ ] **23. Tail Recursion** - Accumulators, stack depth comparison
- [ ] **24. Higher-Order Functions** - Functions as values, composition

## Section 4: Control Flow (25-31)
- [ ] **25. Case Expressions** - Pattern matching on values, guards in case
- [ ] **26. Cond Expressions** - Boolean conditions, first-true-wins
- [ ] **27. If/Unless** - Simple conditionals, macros not special forms
- [ ] **28. With Expressions** - Happy path chaining, else clauses
- [ ] **29. Pipe Operator** - |> pipelines, nested-to-piped refactoring
- [ ] **30. Comprehensions** - for generators, filters, :into
- [ ] **31. Try/Rescue** - Error handling, let it crash philosophy

## Section 5: Enum & Stream (32-40)
- [ ] **32. Enum Basics** - map, filter, reduce, each
- [ ] **33. Enum Transforms** - sort, reverse, uniq, flat_map, zip, chunk_every
- [ ] **34. Enum Aggregates** - count, sum, min/max, frequencies, group_by
- [ ] **35. Enum Search** - find, any?, all?, take_while, drop_while
- [ ] **36. Reduce Mastery** - Step-through animation, implement map/filter with reduce
- [ ] **37. MapSet** - Set operations: union, intersection, difference
- [ ] **38. Streams** - Eager vs lazy, Stream.map/filter/take
- [ ] **39. Stream Generators** - iterate, unfold, cycle, infinite streams
- [ ] **40. Ranges & Slicing** - 1..10, step ranges, Enum.slice/take/drop

## Section 6: Strings, Binaries & Sigils (41-46)
- [ ] **41. String Deep Dive** - UTF-8 binaries, byte_size vs String.length, graphemes
- [ ] **42. Charlists vs Strings** - Single vs double quotes, conversion
- [ ] **43. String Matching** - Binary matching <<h::utf8, rest::binary>>
- [ ] **44. Regex** - ~r//, Regex.match?/run/scan/replace
- [ ] **45. Sigils** - ~s, ~w, ~D, ~T, ~r, uppercase vs lowercase
- [ ] **46. Formatting** - String.pad, IO.inspect options, number formatting

## Section 7: Structs, Protocols & Behaviours (47-54)
- [ ] **47. Structs** - defstruct, @enforce_keys, update syntax
- [ ] **48. Struct Validation** - Constructor patterns, new/1 returning tagged tuples
- [ ] **49. Protocols** - defprotocol/defimpl, dispatch on type
- [ ] **50. Built-in Protocols** - String.Chars, Inspect, Enumerable
- [ ] **51. Behaviours** - @callback, @behaviour, compile-time contracts
- [ ] **52. Polymorphism** - Protocols vs behaviours vs pattern matching
- [ ] **53. Module Attributes** - @moduledoc, @doc, @spec, @type, constants
- [ ] **54. Use & Import** - import, alias, require, use, __using__ macro

## Section 8: Processes & Message Passing (55-62)
- [ ] **55. Spawn & Processes** - spawn/1, self(), process isolation, PIDs
- [ ] **56. Send & Receive** - Message passing, mailbox visualization
- [ ] **57. Process Links** - spawn_link, bidirectional crash propagation
- [ ] **58. Process Monitors** - Process.monitor, :DOWN messages
- [ ] **59. Process State Loop** - Recursive receive loop (DIY GenServer)
- [ ] **60. Trapping Exits** - trap_exit flag, converting exits to messages
- [ ] **61. Task Module** - Task.async/await, async_stream, concurrency
- [ ] **62. Agent** - Simple state server, get/update/get_and_update

## Section 9: GenServer & OTP (63-71)
- [ ] **63. GenServer Basics** - init, handle_call, handle_cast, handle_info
- [ ] **64. Call vs Cast** - Sync vs async, blocking behavior, timeouts
- [ ] **65. GenServer State** - Complex state, named processes, Registry
- [ ] **66. Periodic Work** - Process.send_after, timer patterns
- [ ] **67. Supervisor Basics** - Restart strategies: one_for_one, one_for_all
- [ ] **68. Dynamic Supervisors** - DynamicSupervisor, start_child/terminate_child
- [ ] **69. Supervision Trees** - Nested supervisors, fault tolerance
- [ ] **70. Registry** - Process lookup, :unique vs :duplicate, pub/sub
- [ ] **71. ETS Tables** - :ets operations, table types, concurrent reads

## Section 10: Advanced Patterns (72-75)
- [ ] **72. Quote & Unquote** - AST representation, homoiconicity
- [ ] **73. Macros** - defmacro, compile-time code generation
- [ ] **74. App Config** - Application.get_env, runtime vs compile-time
- [ ] **75. The Elixir Toolbox** - Decision-tree quiz: choosing the right tool

---

# Advanced LiveView Kata Ideas for Senior Elixir Developers

## Performance & Optimization
- [ ] **104. Query Optimization** - N+1 prevention, preloading strategies, Ecto.Query optimization
- [ ] **105. Telemetry Integration** - Adding custom metrics, performance tracking
- [ ] **106. Memory Profiling** - Debugging memory leaks in long-running LiveViews
- [ ] **107. LiveView Mount Caching** - Using `on_mount` for expensive operations
- [ ] **108. ETS Caching Layer** - Building fast lookup caches for LiveView

## Advanced Ecto & Database
- [ ] **109. Multi-Tenancy** - Schema prefix strategies (Postgres schemas)
- [ ] **110. Database Transactions** - Complex multi-step operations with rollbacks
- [ ] **111. Prepared Statements** - Optimizing repeated queries
- [ ] **112. Custom Ecto Types** - Encrypted fields, JSON columns, custom serialization
- [ ] **113. Repo Sharding** - Working with multiple database connections

## OTP & Concurrency
- [ ] **114. GenServer Integration** - LiveView with background workers
- [ ] **115. Task Supervision** - Managing async tasks properly
- [ ] **116. Rate Limiting** - Implementing per-user or per-IP rate limits
- [ ] **117. Circuit Breaker** - Handling external API failures gracefully
- [ ] **118. Process Registry** - Using `Registry` for process discovery

## Security & Authentication
- [ ] **119. CSRF Deep Dive** - Understanding token rotation and protection
- [ ] **120. API Authentication** - JWT tokens in LiveView context
- [ ] **121. Role-Based Access Control (RBAC)** - Implementing permissions system
- [ ] **122. Content Security Policy** - CSP headers with LiveView
- [ ] **123. Input Sanitization** - XSS prevention, HTML escaping strategies

## Advanced Patterns
- [ ] **124. Command Pattern** - Undoable actions with command queue
- [x] **125. State Machines** - Using `:gen_statem` for complex workflows
- [ ] **126. Event Sourcing** - Audit logging and state reconstruction
- [ ] **127. CQRS Pattern** - Separating read/write models
- [ ] **128. Saga Pattern** - Distributed transaction coordination

## Testing & Quality
- [ ] **129. Property-Based Testing** - Using StreamData for LiveView
- [ ] **130. Mocking External Services** - Using Mox in LiveView tests
- [ ] **131. Test Helpers** - Building reusable test utilities
- [ ] **132. Performance Testing** - Load testing LiveView applications
- [ ] **133. Snapshot Testing** - HTML snapshot comparisons

## Production & Deployment
- [ ] **134. Feature Flags** - A/B testing in LiveView
- [ ] **135. Blue-Green Deployments** - Hot code upgrades considerations
- [ ] **136. Health Checks** - Building status endpoints
- [ ] **137. Graceful Degradation** - Fallbacks when WebSocket fails
- [ ] **138. Error Reporting** - Integration with Sentry/AppSignal

## Advanced UI Patterns
- [x] **139. Virtual Scrolling** - Rendering large lists efficiently
- [ ] **140. Optimistic Locking** - Handling concurrent edits
- [ ] **141. Conflict Resolution** - Merging concurrent changes
- [ ] **142. Collaborative Editing** - CRDT basics for real-time collaboration
- [ ] **143. Command Palette** - Spotlight-style search (Cmd+K)

## Integration & APIs
- [ ] **144. GraphQL with Absinthe** - LiveView + GraphQL subscriptions
- [ ] **145. Webhook Handlers** - Processing external webhooks
- [ ] **146. Server-Sent Events (SSE)** - Alternative to WebSockets
- [ ] **147. Phoenix Channels** - Raw channels vs LiveView
- [ ] **148. Background Jobs** - Oban integration with LiveView

## Architecture & Design
- [ ] **149. Context Boundaries** - Proper Phoenix context design
- [ ] **150. Dependency Injection** - Making LiveView testable
- [ ] **151. Ports and Adapters** - Hexagonal architecture in Phoenix
- [ ] **152. Domain Events** - Event-driven architecture
- [ ] **153. The Strangler Pattern** - Migrating legacy apps to LiveView

---

## 🔥 Top 10 Priority for Senior Developers

1. ⭐ **GenServer Integration** (#114) - Critical for real-world apps
2. ⭐ **Multi-Tenancy** (#109) - Common enterprise requirement  
3. ⭐ **RBAC** (#121) - Essential security pattern
4. ⭐ **Telemetry Integration** (#105) - Production observability
5. ⭐ **Feature Flags** (#134) - Modern deployment practice
6. ⭐ **Command Pattern** (#124) - Powerful undo/redo implementation
7. ⭐ **Optimistic Locking** (#140) - Handling concurrent edits
8. ⭐ **Property-Based Testing** (#129) - Advanced testing technique
9. ⭐ **Rate Limiting** (#116) - DoS protection
10. ⭐ **Context Boundaries** (#149) - Clean architecture

---

## Current Kata Status

**Total Existing Katas**: 103  
**Suggested New Katas**: 50  
**Potential Total**: 153 Katas

### Coverage Analysis

Current curriculum excellently covers:
- ✅ Core LiveView mechanics
- ✅ Forms, validation, and changesets
- ✅ PubSub and real-time features
- ✅ JavaScript interop
- ✅ File handling and uploads
- ✅ Testing basics

These suggestions add:
- 🆕 Advanced OTP patterns
- 🆕 Production-ready concerns
- 🆕 Enterprise security patterns
- 🆕 Performance optimization
- 🆕 Advanced testing strategies
- 🆕 Architectural patterns
