# Kata 26: The Text Input

## Overview
This kata introduces the fundamental building block of web interaction: the **Form**. specifically, we focus on the **Text Input**.

In Phoenix LiveView, forms are more than just HTML; they are a two-way synchronization mechanism between the client's input and the server's state.

## Key Concepts

### 1. The `.form` Component
Phoenix provides a functional component `<.form>` (or `Phoenix.Component.form/1`) that wraps the native HTML `<form>` tag. It handles:
- **Change Tracking**: `phx-change` event triggers whenever an input changes.
- **Submission**: `phx-submit` event triggers when the form is submitted (e.g., Enter key or Submit button).
- **CSRF Protection**: Automatically handled.

### 2. Events
- **`phx-change`**: This event is fired *as the user types* (or changes, for other inputs). It allows for real-time validation, character counting, or live previews.
- **`phx-submit`**: This event is fired when the user commits the form.

### 3. Handling Data
For simple forms, you can just use `socket.assigns` and raw parameters. For robust forms, you typically use `Ecto.Changeset` (which we will cover in depth later). In this kata, we will use a **Schemaless Changeset** or just a simple Map to demonstrate the mechanics.

## Step-by-Step Explanation

1.  **Define the Form**: We create a generic map (e.g., `%{text: ""}`) to hold our form data.
2.  **Bind Events**: We add `phx-change="validate"` and `phx-submit="save"` to the form.
3.  **Handle "validate"**: When the user types, the `handle_event("validate", ...)` callback updates the socket state. This causes the UI to re-render, reflecting the value back to the input (controlled component).
4.  **Handle "save"**: When submitted, `handle_event("save", ...)` processes the data (e.g., saves to DB, sends notification).

## The Code Structure
```elixir
<.form for={@form} phx-change="validate" phx-submit="save">
  <.input field={@form[:name]} type="text" label="Name" />
  <button>Save</button>
</.form>
```

> **Pro Tip**: Always use `phx-submit` alongside `phx-change` to ensure your form is accessible to keyboard users (hitting 'Enter' to submit).
