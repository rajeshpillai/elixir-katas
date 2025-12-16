# Kata 33: Formats (Regex Validation)

## Overview
Often, fields require specific formats: emails, phone numbers, zip codes, etc. We use **Regular Expressions (Regex)** to validate these input strings.

## Key Concepts

### 1. Regex in Elixir
Elixir has a `Regex` module. You can create regexes using the sigil `~r/pattern/`.
- `String.match?(value, ~r/pattern/)` returns true/false.

### 2. Common Patterns
- **Email**: `~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/` (Simple version, sufficient for most UI formatting checks. True email validation requires sending an email).
- **Phone**: `~r/^\d{3}-\d{3}-\d{4}$/` (e.g., 555-0199).

### 3. Immediate Feedback
In LiveView, checking format on `phx-change` is delightful. The user sees "Invalid Email" instantly, rather than waiting for a full page reload or submit cycle.

## The Code Structure
```elixir
def handle_event("validate", %{"user" => params}, socket) do
  errors = []
  
  errors = if !String.match?(params["email"], ~r/@/) do
    [email: "Must contain @"] ++ errors
  else
    errors
  end
  
  {:noreply, assign(socket, form: to_form(params, errors: errors))}
end
```
