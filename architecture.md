# Phoenix LiveView Katas Architecture

This document outlines the architecture of the Phoenix LiveView Katas application and provides a guide for adding new katas.

## Architecture Overview

The application is built with **Phoenix LiveView** 1.0+.

### Core Structure
- **Katas as LiveComponents**: Each kata is a **LiveComponent** module located in `lib/elixir_katas_web/live/`.
  - Naming Convention: `kata_XX_name_live.ex` (e.g., `kata_09_tabs_live.ex`).
  - Namespace: `ElixirKatasWeb.KataXXNameLive`.
  - **Dynamic Hosting**: Katas are no longer standalone LiveViews. They are hosted by `KataHostLive` via a single dynamic route: `/katas/:slug`.
- **Shared Layout**:
  - `layouts.ex` defines the main application shell, including the sidebar navigation.
  - `root.html.heex` provides the base HTML structure.
- **Components**:
  - `KataComponents.kata_viewer/1`: A standard UI wrapper used within the host to provide the tabbed interface (Interactive, Source Code, Notes).
- **Notes**: Markdown files in `notes/` provide the educational content for each kata.

---

## How to Add a New Kata

Adding a new kata is largely automated, provided you follow the naming conventions. `KataHostLive` uses file pattern matching to resolve modules and notes without requiring manual registration in the host's source code.

### 1. Create the LiveComponent Module
**Path:** `lib/elixir_katas_web/live/kata_XX_name_live.ex`

Create a new file with the following structure. 
- **Naming**: Must catch `kata_XX_*_live.ex` (where `XX` is two digits).
- **Structure**: Use `use ElixirKatasWeb, :live_component` and the `update/2` callback.

```elixir
defmodule ElixirKatasWeb.KataXXNameLive do
  use ElixirKatasWeb, :live_component

  def update(assigns, socket) do
    # socket = assign(socket, assigns) is often needed to merge incoming assigns
    {:ok, 
     socket
     |> assign(assigns)
     # ... Initialize your kata-specific state here ...
     }
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h2 class="text-2xl font-bold mb-4">Kata XX: [Name]</h2>
      
      <!-- IMPORTANT: Use phx-target={@myself} for all interactive events -->
      <button phx-click="increment" phx-target={@myself} class="...">
        Click Me
      </button>
    </div>
    """
  end

  def handle_event("increment", _params, socket) do
    {:noreply, socket}
  end
end
```

### 2. Create the Notes File
**Path:** `notes/kata_XX_name_notes.md`

- **Naming**: Must match `notes/kata_XX_*_notes.md`.
- **Content**: Use standard Markdown. `KataHostLive` will render this in the "Notes" tab.

### 3. Automatic Registration
You do **not** need to modify `KataHostLive` or `router.ex`. The host will automatically:
- Locate the `.ex` file based on the ID.
- Extract the title from the filename.
- Locate the notes file.
- Compile and render the component in the "Interactive" tab.

### 4. Link the New Kata
To make the kata discoverable, add links in two places:

**Index Page (`lib/elixir_katas_web/live/katas_index_live.ex`):**
Add a card with the `navigate` attribute using the slug `XX-name`.

**Sidebar (`lib/elixir_katas_web/components/layouts.ex`):**
Add a link in the `app/1` function using the same slug format.

```elixir
<.link navigate={~p"/katas/XX-name"} class="...">
  XX - Name
</.link>
```

---

## Multi-user Kata Editing Architecture

The application supports a multi-user environment where logged-in users can edit and run their own versions of any kata without affecting others or the original source code.

### 1. The Host (`KataHostLive`)
Katas are served through a single dynamic route: `live "/katas/:slug", KataHostLive, :index`.
- **Responsibility**: Extracts `kata_id` from the slug, manages the session, loads/saves user-specific source code, and renders the kata as a dynamic `LiveComponent`.
- **Loading Logic**: 
  1. Checks if the user is logged in.
  2. If yes, attempts to load the user's custom version from the `user_katas` table.
  3. Falls back to reading the original template file from disk.

### 2. Dynamic Compilation (`DynamicCompiler`)
To allow users to run modified code simultaneously, each user gets their own ephemeral module.
- **Module Rewriting**: The compiler takes the source code and replaces the original module name (e.g., `ElixirKatasWeb.Kata01HelloWorldLive`) with a unique name based on the `user_id` (e.g., `ElixirKatas.User2.Kata01`).
- **In-Memory Compilation**: Uses `Code.compile_string/1` to load the new module into the BEAM in real-time.
- **Cleanup**: Old versions of the user's module are purged/deleted before new ones are compiled to prevent memory bloat.

### 3. Asynchronous Workflow
Compilation and database persistence are handled asynchronously:
- **Background Task**: `save_source` events trigger a `Task.async`.
- **UX Feedback**: The UI shows "Compiling..." and "✓ Saved!" indicators in the header.
- **Focus Preservation**: Compilation is designed to be non-disruptive, maintaining editor focus and layout stability.

### 4. Strip Logic (Migration Cleanup)
When loading source code for editing, the system automatically strips:
- `File.read!` calls (unsupported in dynamic context).
- Assignments for `source_code` and `notes_content` (handled by the Host).
- `<.kata_viewer>` wrappers (the Host provides this).

---

## Verification Checklist
- [x] Server compiles without errors (`mix compile`).
- [x] All katas accessible via `/katas/:slug`.
- [x] Interactive logic works (tested with Counter, Mirror, etc.).
- [x] Source Code view correctly shows the component code.
- [x] User-specific edits persist and compile in-memory.
- [x] "Revert to Original" works correctly.
