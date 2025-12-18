# Phoenix LiveView Katas Architecture

This document outlines the architecture of the Phoenix LiveView Katas application and provides a guide for adding new katas.

## Architecture Overview

The application is built with **Phoenix LiveView** 1.0+.

### Core Structure
- **Katas as LiveViews**: Each kata is a distinct LiveView module located in `lib/elixir_katas_web/live/`.
  - Naming Convention: `kata_XX_name_live.ex` (e.g., `kata_09_tabs_live.ex`).
  - Namespace: `ElixirKatasWeb.KataXXNameLive`.
- **Shared Layout**:
  - `layouts.ex` defines the main application shell, including the sidebar navigation.
  - `root.html.heex` provides the base HTML structure.
- **Components**:
  - `KataComponents.kata_viewer/1`: The standard wrapper for all katas. It handles the tabbed interface (Interactive, Source, Notes) and layout consistency.
- **Notes**: Markdown files in `notes/` provide the educational content for each kata.

---

## How to Add a New Kata

Adding a new kata involves touching 5 distinct files. Follow this checklist:

For each kata add the "Interactive", "Source Code" and "Notes" tabs.

### 1. Create the LiveView Module
**Path:** `lib/elixir_katas_web/live/kata_XX_name_live.ex`

Create a new file with the following structure. Replace `XX` and `Name` appropriately.

```elixir
defmodule ElixirKatasWeb.KataXXNameLive do
  use ElixirKatasWeb, :live_view
  import ElixirKatasWeb.KataComponents

  def mount(_params, _session, socket) do
    # Load source code and notes for the viewer
    source_code = File.read!(__ENV__.file)
    notes_content = File.read!("notes/kata_XX_name_notes.md")

    {:ok, 
     socket
     |> assign(active_tab: "interactive") # Required for KataViewer
     |> assign(source_code: source_code)
     |> assign(notes_content: notes_content)
     # ... Initialize your kata-specific state here ...
     }
  end

  def render(assigns) do
    ~H"""
    <.kata_viewer 
      active_tab={@active_tab} 
      title="Kata XX: [Name]" 
      source_code={@source_code} 
      notes_content={@notes_content}
    >
      <!-- YOUR KATA UI GOES HERE -->
      <div class="p-4">
        ...
      </div>
    </.kata_viewer>
    """
  end

  # Required for KataViewer tab switching
  def handle_event("set_tab", %{"tab" => tab}, socket) do
    # Handle viewer tabs
    if tab in ["interactive", "source", "notes"] do
       {:noreply, assign(socket, active_tab: tab)}
    else
       # Handle your internal kata tabs/events if any
       {:noreply, socket} 
    end
  end

  # ... Your specific event handlers ...
end
```

### 2. Create the Notes File
**Path:** `notes/kata_XX_name_notes.md`

Create a markdown file explaining the concept.

```markdown
# Kata XX: [Name]

## The Goal
...

## Key Concepts
- ...
- ...

## The Solution
...
```

### 3. Add the Route
**Path:** `lib/elixir_katas_web/router.ex`

Add a new line to the `live_session :default` block:

```elixir
live "/katas/XX-name", KataXXNameLive
```

### 4. Update the Index Page
**Path:** `lib/elixir_katas_web/live/katas_index_live.ex`

Add a new `<.link>` card to the grid in `render/1`. Follow the existing pattern.

```elixir
<.link navigate="/katas/XX-name" class="card ...">
  ...
</.link>
```

### 5. Update the Sidebar
**Path:** `lib/elixir_katas_web/components/layouts.ex`

Add a new navigation link to the standard app layout in the `app/1` function.

```elixir
<.link navigate="/katas/XX-name" class="...">
  ...
</.link>
```

---

## Multi-user Kata Editing Architecture

The application supports a multi-user environment where logged-in users can edit and run their own versions of any kata without affecting others or the original source code.

### 1. The Host (`KataHostLive`)
Instead of accessing katas directly, they are served through `KataHostLive`.
- **Responsibility**: Manages the multi-user session, loads/saves user-specific source code, and handles the "Interactive" tab by rendering the dynamically compiled module.
- **Loading Logic**: 
  1. Checks if the user is logged in.
  2. If yes, attempts to load the user's custom version from the `user_katas` table.
  3. Falls back to reading the original template file from disk.

### 2. Dynamic Compilation (`DynamicCompiler`)
To allow users to run modified code simultaneously, each user gets their own ephemeral module.
- **Module Rewriting**: The compiler takes the source code and replaces the original module name (e.g., `ElixirKatasWeb.Kata01HelloWorldLive`) with a unique name based on the `user_id` (e.g., `ElixirKatas.U123.Kata01`).
- **In-Memory Compilation**: Uses `Code.compile_string/1` to load the new module into the BEAM in real-time.
- **Lifecycle**: Old versions of the user's module are purged/deleted before new ones are compiled to prevent memory bloat and stale state.

### 3. Asynchronous Workflow
Compilation is CPU-intensive (~400ms). To maintain UI responsiveness:
- **Background Task**: `save_source` events trigger a `Task.async` to handle compilation and database persistence.
- **Status Indicators**: The UI shows a "Compiling..." spinner and a temporary "✓ Saved!" indicator in the header once complete.
- **Non-Disruptive Errors**: Compilation errors are caught and displayed in an absolutely positioned banner at the bottom of the editor, preventing layout shifts and focus loss.

### 4. Persistence Layer
- **Schema**: `ElixirKatas.Katas.UserKata` stores `user_id`, `kata_name`, and `source_code`.
- **Constraint**: A unique index on `[user_id, kata_name]` ensures each user has exactly one personal version of each kata.

---

## Verification Checklist
- [x] Server compiles without errors (`mix phx.server`).
- [x] Route `/katas/01-hello-world` is accessible.
- [x] Compilation works for guests (In-memory only).
- [x] Compilation works for logged-in users (In-memory + DB persistence).
- [x] "Revert to Original" restores the source from disk and deletes DB record.
- [x] Editor focus is maintained during auto-saves.
- [x] Syntax errors show up in the non-disruptive banner.
