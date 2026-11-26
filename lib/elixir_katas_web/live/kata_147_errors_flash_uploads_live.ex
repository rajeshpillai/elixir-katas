defmodule ElixirKatasWeb.Kata147ErrorsFlashUploadsLive do
  @moduledoc """
  Lesson 7: Error Handling, Flash & Uploads

  Key concepts:
  - Flash messages (:info and :error) via put_flash/3
  - Error handling patterns with try/rescue in handle_event
  - Graceful form validation and error display
  - File uploads with allow_upload, live_file_input, live_img_preview
  - Upload progress tracking and consume_uploaded_entries

  Ported from phoenix-liveview-tutorial (lesson7_error_handling_live.ex).
  In the tutorial this is a full LiveView; here it runs as a LiveComponent
  inside the kata host LiveView:
  - `put_flash/3` in a LiveComponent sets the component's own `@flash`; it is
    copied to the parent LiveView (and its layout's `flash_group`) only on
    `push_patch/2` or `push_navigate/2`. So this kata renders its `@flash`
    itself with the same `<.flash>` toasts the layout uses (`phx-target` makes
    the close button clear the component's flash).
  - `allow_upload/3` runs in the one-time init (instead of `mount/3`) and the
    upload form targets this component with `phx-target={@myself}`.
  - Uploaded files are saved under `priv/static/uploads` with a generated
    name, never with the client's file name (the tutorial used the client
    name in a tmp-dir path).
  """
  use ElixirKatasWeb, :live_component

  @code_flash_snippet ~S'''
  def handle_event("flash_info", _params, socket) do
    {:noreply, put_flash(socket, :info, "This is an informational message.")}
  end

  def handle_event("flash_error", _params, socket) do
    {:noreply, put_flash(socket, :error, "Something went wrong!")}
  end
  '''

  @code_error_snippet ~S'''
  def handle_event("risky_operation", _params, socket) do
    try do
      result = perform_operation()  # may raise
      {:noreply, put_flash(socket, :info, "Operation succeeded: #{result}")}
    rescue
      e ->
        {:noreply, put_flash(socket, :error, "Operation failed: #{Exception.message(e)}")}
    end
  end
  '''

  @code_upload_snippet ~S'''
  # In mount/3 (in this kata: the one-time init in update/2):
  |> allow_upload(:avatar,
    accept: ~w(.jpg .jpeg .png),
    max_entries: 1,
    max_file_size: 5_000_000
  )

  # In the template (a LiveComponent's form needs phx-target={@myself}):
  <.live_file_input upload={@uploads.avatar} />
  <.live_img_preview entry={entry} />

  # In handle_event:
  def handle_event("save_upload", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        # Never build a path from entry.client_name: generate the name.
        dest = Path.join("priv/static/uploads", "#{entry.uuid}#{ext(entry)}")
        File.cp!(path, dest)
        {:ok, dest}
      end)

    {:noreply, put_flash(socket, :info, "Uploaded!")}
  end
  '''

  @upload_dir "priv/static/uploads"

  def update(assigns, socket) do
    if socket.assigns[:__initialized__] do
      {:ok, assign(socket, assigns)}
    else
      {:ok, socket |> assign(assigns) |> assign(:__initialized__, true) |> init()}
    end
  end

  defp init(socket) do
    socket
    |> assign(
      operation_log: [],
      validation_form: to_form(%{"email" => "", "age" => ""}, as: "user"),
      validation_errors: %{},
      uploaded_file_path: nil,
      code_flash: @code_flash_snippet,
      code_error: @code_error_snippet,
      code_upload: @code_upload_snippet
    )
    |> allow_upload(:avatar,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1,
      max_file_size: 5_000_000
    )
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <%!-- Kata only: a LiveComponent's flash is not copied to the parent LiveView
           unless it patches/navigates, so render it here with the layout's toast. --%>
      <.flash kind={:info} flash={@flash} id="kata-147-flash-info" phx-target={@myself} />
      <.flash kind={:error} flash={@flash} id="kata-147-flash-error" phx-target={@myself} />
      <h1 class="text-2xl font-bold">Error Handling, Flash & Uploads</h1>

      <%!-- SECTION 1: Flash Messages --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">Flash Messages</h2>
          <p class="text-sm opacity-70">
            Flash messages appear via the <code>flash_group</code> component in the layout.
            Use <code>put_flash/3</code> with <code>:info</code> or <code>:error</code> kinds.
            Click a button and watch the toast appear in the top-right corner.
          </p>
          <p class="text-xs opacity-60">
            In this kata the demo is a LiveComponent. A component's <code>put_flash/3</code>
            sets the component's own <code>@flash</code>, which reaches the parent LiveView's
            layout only on <code>push_patch/2</code>
            or <code>push_navigate/2</code>, so the
            kata renders the toasts itself with <code>&lt;.flash flash=&#123;@flash&#125;&gt;</code>.
          </p>

          <div class="flex flex-wrap gap-3 mt-3">
            <button
              phx-click="flash_info"
              phx-target={@myself}
              class="btn btn-sm btn-info"
            >
              Info Flash
            </button>

            <button
              phx-click="flash_error"
              phx-target={@myself}
              class="btn btn-sm btn-error"
            >
              Error Flash
            </button>

            <button
              phx-click="flash_success"
              phx-target={@myself}
              class="btn btn-sm btn-success"
            >
              Success Message (via :info)
            </button>
          </div>

          <div class="mt-3 p-3 bg-base-300 rounded text-xs font-mono whitespace-pre-wrap">
            <code>{@code_flash}</code>
          </div>
        </div>
      </div>

      <%!-- SECTION 2: Error Handling Patterns --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">Error Handling Patterns</h2>
          <p class="text-sm opacity-70">
            Demonstrates <code>try/rescue</code> in event handlers, random success/failure
            simulation, and form validation with graceful error display.
          </p>

          <%!-- Simulated operation --%>
          <div class="mt-3">
            <h3 class="font-semibold text-sm mb-2">Simulated Operation (Random Success/Failure)</h3>
            <p class="text-xs opacity-60 mb-2">
              Each click has a ~50% chance of succeeding. Failures are caught with
              <code>try/rescue</code>
              and reported via <code>put_flash</code>.
            </p>
            <button
              phx-click="risky_operation"
              phx-target={@myself}
              class="btn btn-sm btn-warning"
            >
              Run Risky Operation
            </button>

            <div :if={@operation_log != []} class="mt-2 space-y-1 max-h-32 overflow-y-auto">
              <div
                :for={entry <- Enum.take(@operation_log, 10)}
                class={[
                  "text-xs font-mono p-1 rounded",
                  entry.success && "bg-success/10 text-success",
                  not entry.success && "bg-error/10 text-error"
                ]}
              >
                [{entry.timestamp}] {entry.message}
              </div>
            </div>
          </div>

          <div class="divider"></div>

          <%!-- Form validation --%>
          <div>
            <h3 class="font-semibold text-sm mb-2">Form Validation with Error Display</h3>
            <p class="text-xs opacity-60 mb-2">
              Validates email format and age range on submit. Errors are displayed
              inline without crashing the LiveView.
            </p>

            <.form
              for={@validation_form}
              id="kata-147-validation-form"
              phx-submit="validate_form"
              phx-target={@myself}
              class="space-y-3 max-w-sm"
            >
              <div>
                <label class="label">
                  <span class="label-text text-sm">Email</span>
                </label>
                <input
                  type="text"
                  name="user[email]"
                  value={@validation_form[:email].value}
                  placeholder="user@example.com"
                  class={[
                    "input input-bordered input-sm w-full",
                    @validation_errors[:email] && "input-error"
                  ]}
                />
                <p :if={@validation_errors[:email]} class="text-error text-xs mt-1">
                  {@validation_errors[:email]}
                </p>
              </div>

              <div>
                <label class="label">
                  <span class="label-text text-sm">Age</span>
                </label>
                <input
                  type="text"
                  name="user[age]"
                  value={@validation_form[:age].value}
                  placeholder="18-120"
                  class={[
                    "input input-bordered input-sm w-full",
                    @validation_errors[:age] && "input-error"
                  ]}
                />
                <p :if={@validation_errors[:age]} class="text-error text-xs mt-1">
                  {@validation_errors[:age]}
                </p>
              </div>

              <button type="submit" class="btn btn-sm btn-primary">
                Validate & Submit
              </button>
            </.form>
          </div>

          <div class="mt-3 p-3 bg-base-300 rounded text-xs font-mono whitespace-pre-wrap">
            <code>{@code_error}</code>
          </div>
        </div>
      </div>

      <%!-- SECTION 3: File Upload --%>
      <div class="card bg-base-200">
        <div class="card-body">
          <h2 class="card-title text-lg">File Upload</h2>
          <p class="text-sm opacity-70">
            Uses <code>allow_upload/3</code> in mount, <code>&lt;.live_file_input&gt;</code> for
            the file picker, <code>&lt;.live_img_preview&gt;</code> for client-side image preview,
            and <code>consume_uploaded_entries/3</code> on submit.
          </p>

          <.form
            for={%{}}
            id="kata-147-upload-form"
            phx-submit="save_upload"
            phx-change="validate_upload"
            phx-target={@myself}
            class="mt-3 space-y-3"
          >
            <div
              class="border-2 border-dashed border-base-content/20 rounded-lg p-6 text-center hover:border-primary/50 transition-colors"
              phx-drop-target={@uploads.avatar.ref}
            >
              <div class="text-sm opacity-70 mb-2">
                Drag and drop an image here, or click to select
              </div>
              <label
                for={@uploads.avatar.ref}
                class="btn btn-sm btn-outline cursor-pointer"
              >
                Choose Image <.live_file_input upload={@uploads.avatar} class="hidden" />
              </label>
              <p class="text-xs opacity-50 mt-2">
                Accepts: .jpg, .jpeg, .png &mdash; Max size: 5 MB
              </p>
            </div>

            <%!-- Upload entries: preview + progress --%>
            <div :for={entry <- @uploads.avatar.entries} class="space-y-2">
              <div class="flex items-center gap-3">
                <div class="w-20 h-20 rounded overflow-hidden bg-base-300 flex-shrink-0">
                  <.live_img_preview entry={entry} class="w-full h-full object-cover" />
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-mono truncate">{entry.client_name}</p>
                  <p class="text-xs opacity-50">
                    {Float.round(entry.client_size / 1_000_000, 2)} MB
                  </p>
                  <div class="flex items-center gap-2 mt-1">
                    <progress
                      class="progress progress-primary flex-1"
                      value={entry.progress}
                      max="100"
                    ></progress>
                    <span class="text-xs font-mono w-10 text-right">{entry.progress}%</span>
                  </div>

                  <%!-- Upload errors for this entry --%>
                  <div
                    :for={err <- upload_errors(@uploads.avatar, entry)}
                    class="text-error text-xs mt-1"
                  >
                    {upload_error_to_string(err)}
                  </div>
                </div>
                <button
                  type="button"
                  phx-click="cancel_upload"
                  phx-target={@myself}
                  phx-value-ref={entry.ref}
                  class="btn btn-ghost btn-xs text-error"
                >
                  &times;
                </button>
              </div>
            </div>

            <%!-- General upload errors (e.g., too many files) --%>
            <div :for={err <- upload_errors(@uploads.avatar)} class="text-error text-xs">
              {upload_error_to_string(err)}
            </div>

            <button
              type="submit"
              class="btn btn-sm btn-primary"
              disabled={@uploads.avatar.entries == []}
            >
              Upload
            </button>
          </.form>

          <div
            :if={@uploaded_file_path}
            class="mt-3 p-3 bg-success/10 border border-success/30 rounded text-sm"
          >
            File saved successfully to: <code class="text-xs">{@uploaded_file_path}</code>
          </div>

          <div class="mt-3 p-3 bg-base-300 rounded text-xs font-mono whitespace-pre-wrap">
            <code>{@code_upload}</code>
          </div>
        </div>
      </div>

      <%!-- SECTION 4: Teaching notes --%>
      <div class="card bg-info/10 border border-info/30">
        <div class="card-body text-sm space-y-2">
          <h3 class="font-bold">Key Takeaways</h3>
          <ul class="list-disc list-inside space-y-1 opacity-80">
            <li>
              <code>put_flash(socket, :info | :error, message)</code> sets flash messages
              &mdash; the layout's <code>flash_group</code> renders them automatically
            </li>
            <li>
              Use <code>try/rescue</code> in <code>handle_event/3</code> to catch exceptions
              and report them via flash instead of crashing the LiveView
            </li>
            <li>
              Never let an unhandled exception crash a LiveView in production &mdash;
              always rescue and communicate errors to the user
            </li>
            <li>
              <code>allow_upload/3</code> in <code>mount/3</code> configures accepted types,
              max entries, and max file size
            </li>
            <li>
              <code>&lt;.live_file_input&gt;</code>
              renders the file picker; <code>&lt;.live_img_preview&gt;</code>
              shows a client-side preview before upload
            </li>
            <li>
              <code>consume_uploaded_entries/3</code> processes uploaded files on submit &mdash;
              each entry provides <code>%&#123;path: temp_path&#125;</code> and entry metadata
            </li>
            <li>
              <code>upload_errors/1</code> and <code>upload_errors/2</code> return errors for
              the upload config or a specific entry (e.g., <code>:too_large</code>, <code>:not_accepted</code>)
            </li>
            <li>
              The <code>phx-drop-target</code> attribute enables drag-and-drop on any container
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  # -- Flash Events --

  def handle_event("flash_info", _params, socket) do
    {:noreply,
     put_flash(
       socket,
       :info,
       "This is an informational message. Everything is working as expected."
     )}
  end

  def handle_event("flash_error", _params, socket) do
    {:noreply, put_flash(socket, :error, "Something went wrong! This is an error flash message.")}
  end

  def handle_event("flash_success", _params, socket) do
    {:noreply,
     put_flash(
       socket,
       :info,
       "Operation completed successfully! (Success messages use the :info kind.)"
     )}
  end

  # -- Error Handling Events --

  def handle_event("risky_operation", _params, socket) do
    timestamp = Time.utc_now() |> Time.truncate(:second) |> to_string()

    try do
      result = perform_risky_operation()

      entry = %{success: true, timestamp: timestamp, message: "Success: #{result}"}
      log = [entry | socket.assigns.operation_log]

      socket =
        socket
        |> assign(operation_log: log)
        |> put_flash(:info, "Operation succeeded: #{result}")

      {:noreply, socket}
    rescue
      e ->
        entry = %{
          success: false,
          timestamp: timestamp,
          message: "Failed: #{Exception.message(e)}"
        }

        log = [entry | socket.assigns.operation_log]

        socket =
          socket
          |> assign(operation_log: log)
          |> put_flash(:error, "Operation failed: #{Exception.message(e)}")

        {:noreply, socket}
    end
  end

  # -- Form Validation Events --

  def handle_event("validate_form", %{"user" => params}, socket) do
    errors = validate_user_params(params)

    socket =
      socket
      |> assign(
        validation_form: to_form(params, as: "user"),
        validation_errors: errors
      )

    case errors do
      empty when map_size(empty) == 0 ->
        {:noreply,
         put_flash(
           socket,
           :info,
           "Form is valid! Email: #{params["email"]}, Age: #{params["age"]}"
         )}

      _ ->
        error_count = map_size(errors)

        {:noreply,
         put_flash(
           socket,
           :error,
           "Validation failed: #{error_count} error(s) found. Please fix and resubmit."
         )}
    end
  end

  # -- Upload Events --

  def handle_event("validate_upload", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_event("save_upload", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        # The client's file name is untrusted: never use it in a path.
        File.mkdir_p!(@upload_dir)
        dest = Path.join(@upload_dir, "liveview_lab_#{entry.uuid}#{ext(entry)}")
        File.cp!(path, dest)
        {:ok, dest}
      end)

    case uploaded_files do
      [file_path | _] ->
        socket =
          socket
          |> assign(uploaded_file_path: file_path)
          |> put_flash(:info, "File uploaded successfully to #{file_path}")

        {:noreply, socket}

      [] ->
        {:noreply, put_flash(socket, :error, "No file was uploaded. Please select a file first.")}
    end
  end

  # -- Private Helpers --

  # Extension from the client name, limited to the accepted types.
  defp ext(entry) do
    ext = entry.client_name |> Path.basename() |> Path.extname() |> String.downcase()
    if ext in ~w(.jpg .jpeg .png), do: ext, else: ""
  end

  defp perform_risky_operation do
    # Simulate a 50/50 success/failure
    case :rand.uniform(2) do
      1 ->
        result_id = :rand.uniform(10_000)
        "Processed record ##{result_id}"

      2 ->
        raise RuntimeError, "Database connection timed out after 5000ms"
    end
  end

  defp validate_user_params(params) do
    errors = %{}

    errors =
      case params["email"] do
        nil ->
          Map.put(errors, :email, "Email is required")

        email when byte_size(email) == 0 ->
          Map.put(errors, :email, "Email is required")

        email ->
          if String.match?(email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/) do
            errors
          else
            Map.put(errors, :email, "Must be a valid email address (e.g., user@example.com)")
          end
      end

    errors =
      case params["age"] do
        nil ->
          Map.put(errors, :age, "Age is required")

        age when byte_size(age) == 0 ->
          Map.put(errors, :age, "Age is required")

        age ->
          case Integer.parse(age) do
            {num, ""} when num >= 18 and num <= 120 ->
              errors

            {num, ""} when num < 18 ->
              Map.put(errors, :age, "Must be at least 18 years old")

            {num, ""} when num > 120 ->
              Map.put(errors, :age, "Must be 120 or younger")

            _ ->
              Map.put(errors, :age, "Must be a valid number between 18 and 120")
          end
      end

    errors
  end

  defp upload_error_to_string(:too_large), do: "File is too large (max 5 MB)"

  defp upload_error_to_string(:not_accepted),
    do: "File type not accepted (use .jpg, .jpeg, or .png)"

  defp upload_error_to_string(:too_many_files), do: "Too many files selected (max 1)"
  defp upload_error_to_string(:external_client_failure), do: "External client upload failed"
  defp upload_error_to_string(err), do: "Upload error: #{inspect(err)}"
end
