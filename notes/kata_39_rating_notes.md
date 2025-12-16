# Kata 39: The Rating Input

## Overview
HTML doesn't have a `<input type="rating">` (yet). To build a 5-star rating component, we often use a hidden input for the actual form submission, and separate UI buttons (stars) to update that hidden input's value.

## Key Concepts

### 1. Hidden Inputs
The "source of truth" for the form should usually be a standard input, even if hidden.
```html
<input type="hidden" name="rating" value={@rating} />
```

### 2. UI Synchronization
We render 5 buttons (SVG stars). When a star is clicked:
1.  `phx-click="rate" phx-value-score="3"` fires.
2.  LiveView updates `socket.assigns.rating` to 3.
3.  Re-renders: The hidden input updates to `value="3"`, and the UI highlights 3 stars.

### 3. Styling
We can visually distinguish the "active" stars (filled yellow) from "inactive" stars (gray outline) based on whether their index is `<= @rating`.

## The Code Structure
```elixir
def render(assigns) do
  ~H\"\"\"
    <%= for i <- 1..5 do %>
      <button phx-click="rate" phx-value-score={i}>
        <.star filled={i <= @rating} />
      </button>
    <% end %>
    <input type="hidden" name="rating" value={@rating} />
  \"\"\"
end
```
