# Kata 30: The Multi-Select Form

## Overview
A **Multi-Select** form input allows users to choose multiple options from a list. This is distinct from Kata 23 (which was a custom UI); here we use the native HTML `<select multiple>` element.

## Key Concepts

### 1. The `multiple` Attribute
Adding the `multiple` attribute to a `<select>` tag changes its behavior.
- Users can generally hold Ctrl/Cmd to select multiple items.
- The UI typically shows a scrolling list box instead of a dropdown.
- Browser sends data as multiple keys: `interests[]=coding&interests[]=music`.

### 2. Handling Multiple Values
Phoenix (via Plug) automatically parses repeated keys ending in `[]` into a list.
- In `handle_event("validate", %{"interests" => ["coding", "music"]}, socket)`: You receive a list.
- Note: If *nothing* is selected, the browser might not send the key at all (similar to checkboxes). Phoenix often handles this by sending an empty list if using Form helpers, or you might need a hidden input with empty value depending on setup.

### 3. Rendering Selected Options
When rendering the options, you must check if the value is *in the list* of currently selected values.
`Phoenix.HTML.Form.options_for_select/2` handles this automatically if you pass a list as the selected value.

## The Code Structure
```elixir
<.form for={@form} phx-change="validate">
  <select name="interests[]" multiple class="form-select h-32">
    <%= Phoenix.HTML.Form.options_for_select(@all_interests, @form[:interests].value) %>
  </select>
</.form>
```
Note the `[]` in the name, which helps some parsers and hints intention, though Phoenix is smart about strictly defined schemas. For schemaless params, using `name="interests[]"` ensures it's treated as a list even if only one item is selected.
