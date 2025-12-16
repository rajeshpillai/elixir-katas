# Kata 40: File Uploads

## Overview
LiveView has built-in support for reactive file uploads.
It handles drag-and-drop, progress tracking, and constraints (size, type) out of the box.

## Key Concepts

### 1. `allow_upload/3`
In `mount`, we declare the upload configuration.
```elixir
allow_upload(socket, :avatar, accept: ~w(.jpg .jpeg .png), max_entries: 2)
```

### 2. Input Binding
In the template, we use specialized bindings:
- `<.live_file_input upload={@uploads.avatar} />`: The file picker.
- `<div phx-drop-target={@uploads.avatar.ref}>`: Area for drag/drop.

### 3. Previews
We can render previews of selected files before they are uploaded to the server (client-side preview).
```elixir
<.live_img_preview entry={entry} width="75" />
```

### 4. Consumption
On submit, we "consume" the uploaded entries.
```elixir
consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
  # Move file from tmp path to permanent storage
  dest = Path.join("priv/static/uploads", Path.basename(path))
  File.cp!(path, dest)
  {:ok, "/uploads/" <> Path.basename(path)}
end)
```
*Note: In this specific kata environment, we'll verify the logical flow and maybe simulate "saving" by just acknowledging the file details, to avoid file permission complexities in the lab environment.*
