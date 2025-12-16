# Kata 27: The Checkbox

## Overview
Checkboxes allow users to select boolean values (True/False) or select multiple independent options from a set. This kata focuses on the single boolean case: "Do you agree?" or "Subscribe?".

## Key Concepts

### 1. HTML Checkbox Quirks
In standard HTML forms, if a checkbox is **unchecked**, the browser **does not send any value** for it in the POST request. It simply omits the key. This makes handling unchecked states tricky on the server.

### 2. Phoenix's Solution: The Hidden Input
Phoenix's `<.input type="checkbox">` component (or `generic_input` via `Phoenix.HTML.Form.checkbox`) solves this by generating a hidden input *before* the checkbox with the same name and a "false" value (usually "false" or "0").
- If unchecked: The hidden input's value is sent.
- If checked: The checkbox's value (usually "true") overrides the hidden input (since it appears later in the DOM or form data order).

### 3. Binding to Booleans
In your LiveView `socket.assigns` (or Changeset), your data field should be a boolean. The form parameters will come in as strings ("true" / "false"), which you may need to cast if you aren't using Ecto Changesets (which do it automatically).

## The Code Structure
```elixir
<.form for={@form} phx-change="validate">
  <.input field={@form[:terms]} type="checkbox" label="I agree to terms" />
</.form>
```

## "Checked" Attribute
You generally don't utilize the `checked` attribute manually in LiveView. Instead, you rely on the `value={@form[:field].value}`. If the value is truthy, LiveView adds the `checked` attribute; otherwise, it removes it.
