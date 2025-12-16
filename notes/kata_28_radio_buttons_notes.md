# Kata 28: Radio Buttons

## Overview
Radio buttons are used when users must select **exactly one** option from a set of mutually exclusive choices.

## Key Concepts

### 1. Grouping by Name
Radio buttons behave as a group when they share the same `name` attribute. The browser ensures only one radio with a given name is checked at a time.
- In Phoenix forms: `name="plan"` (or `name="user[plan]"`).

### 2. The `value` Attribute
Unlike checkboxes (which are often boolean), each radio button in a group has a distinct `value`.
- Option A: `value="free"`
- Option B: `value="pro"`

### 3. checked state
The `checked` attribute determines which one is selected.
- In LiveView/HTML: You compare the current value in your state (`@form[:plan].value`) with the radio button's own value. If they match, `checked` is true.

## The Code Structure
```elixir
<.form for={@form} phx-change="validate">
  <label>
    <input type="radio" name="plan" value="free" checked={@form[:plan].value == "free"} />
    Free Plan
  </label>
  
  <label>
    <input type="radio" name="plan" value="pro" checked={@form[:plan].value == "pro"} />
    Pro Plan
  </label>
</.form>
```
Using the `Phoenix.HTML.Form.normalize_value` helper is safer to handle string/atom mismatches if needed.

## Styling
Custom styling radio buttons often involves creating a visual wrapper (like a card) and hiding the actual input, or using CSS `accent-color`.
