# Kata 31: Dependent Inputs

## Overview
**Dependent Inputs** (or cascading dropdowns) are a classic LiveView use case. The set of options available in one input depends on the value selected in another.

A common example: Selecting a **Country** filters the available **Cities**.

## Key Concepts

### 1. State-Driven Options
The list of "Cities" is not static. It resides in `socket.assigns` (e.g., `@cities`).
When the "Country" input changes (triggering `handle_event("validate", ...)`), the server:
1.  Reads the new country ID.
2.  Fetches/Calculates the relevant cities.
3.  Updates `@cities` in the socket.
4.  LiveView re-renders *only* the city dropdown with new options.

### 2. Resetting Dependent Values
When the parent input (Country) changes, the child input (City) usually becomes invalid. You should reset the child's value to empty or a default to prevent submitting a mismatched pair (e.g., Country: USA, City: Paris).

## The Code Structure
```elixir
def handle_event("validate", %{"country" => country}, socket) do
  cities = Cities.list_by_country(country)
  {:noreply, assign(socket, cities: cities, form: to_form(%{"country" => country, "city" => ""}))}
end
```

## Optimizing with `phx-target`
If your form is large, you might want to scope events. However, for dependent inputs, a standard `phx-change` on the form or the specific input works well. LiveView's diff tracking ensures only the changed parts (the dropdown options) are sent over the wire.
