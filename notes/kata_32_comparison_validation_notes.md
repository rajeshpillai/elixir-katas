# Kata 32: Comparison Validation

## Overview
Comparing two fields is a standard requirement for "Confirm Password" or "Confirm Email" scenarios.
We need to ensure `password == password_confirmation`.

## Key Concepts

### 1. Manual Validation vs Changeset
While `Ecto.Changeset.validate_confirmation/3` is the standard way to do this in production apps, we can understand the logic by implementing it manually in `handle_event("validate", ...)`.

### 2. Error Feedback
We only want to show the mismatch error if:
- The user has typed into *both* fields.
- Or specifically, if `password_confirmation` is not empty and doesn't match.

## The Code Structure
```elixir
def handle_event("validate", %{"user" => params}, socket) do
  errors = []
  
  errors = if params["password"] != params["confirmation"] do
    [confirmation: "Passwords do not match"] ++ errors
  else
    errors
  end
  
  {:noreply, assign(socket, form: to_form(params, errors: errors))}
end
```
Using `to_form(params, errors: ...)` allows standard `<.error>` components to render automatically if utilizing `Phoenix.Component.form`.
