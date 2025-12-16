# Kata 29: The Select

## Overview
A **Select** (or Dropdown) input allows users to choose one option from a list. It acts similarly to radio buttons but is more compact, occupying less screen real estate.

## Key Concepts

### 1. Generating Options
In Phoenix, we often use `Phoenix.HTML.Form.options_for_select/2` to generate the inner `<option>` tags, but we can also write them manually or use a simple loop.
The structure is: `<option value="server_value">Display Label</option>`.

### 2. Default Values
To set a default selected option, we can use the `selected` attribute on the option, but in LiveView form contexts, we simply ensure the `@form` parameter has the matching value. The browser will check the correct option.

### 3. Change Events
Just like other inputs, `<select>` triggers `phx-change`. This is commonly used for filtering data or immediate navigation.

## The Code Structure
```elixir
<.form for={@form} phx-change="validate">
  <select name="role" id="role" class="form-select">
    <%= Phoenix.HTML.Form.options_for_select(
          [{"Admin", "admin"}, {"Editor", "editor"}, {"User", "user"}],
          @form[:role].value
        ) %>
  </select>
</.form>
```

Alternatively, manually:
```elixir
<select name="role">
  <%= for role <- ["admin", "editor", "user"] do %>
    <option value={role} selected={@form[:role].value == role}><%= role %></option>
  <% end %>
</select>
```
