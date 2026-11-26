defmodule ElixirKatasWeb.LiveviewLab.Kata147Test do
  use ElixirKatasWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/liveview-katas/147-errors-flash-uploads"

  test "flash buttons put flash on the page", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    refute has_element?(view, "#kata-147-flash-info")

    view |> element("button", "Info Flash") |> render_click()
    assert has_element?(view, "#kata-147-flash-info", "Everything is working as expected.")

    view |> element("button", "Error Flash") |> render_click()
    assert has_element?(view, "#kata-147-flash-error", "This is an error flash message.")

    view |> element("button", "Success Message") |> render_click()
    assert has_element?(view, "#kata-147-flash-info", "Operation completed successfully!")

    # The close button clears the component's flash (lv:clear-flash, phx-target).
    view |> element("#kata-147-flash-error") |> render_click()
    refute has_element?(view, "#kata-147-flash-error")
  end

  test "risky operation logs a result and flashes", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("button", "Run Risky Operation") |> render_click()

    assert (html =~ "Success: Processed record #" and
              has_element?(view, "#kata-147-flash-info", "Operation succeeded:")) or
             (html =~ "Failed: Database connection timed out" and
                has_element?(view, "#kata-147-flash-error", "Operation failed:"))
  end

  test "form validation shows inline errors and a flash", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html =
      view
      |> form("#kata-147-validation-form", user: %{email: "nope", age: "12"})
      |> render_submit()

    assert html =~ "Must be a valid email address"
    assert html =~ "Must be at least 18 years old"
    assert has_element?(view, "#kata-147-flash-error", "Validation failed: 2 error(s) found.")

    html =
      view
      |> form("#kata-147-validation-form", user: %{email: "a@b.co", age: "30"})
      |> render_submit()

    assert has_element?(view, "#kata-147-flash-info", "Form is valid! Email: a@b.co, Age: 30")
    refute html =~ "Must be a valid email address"
  end

  test "uploads an image with a generated file name", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    avatar =
      file_input(view, "#kata-147-upload-form", :avatar, [
        %{name: "../../evil.png", content: "fake png bytes", type: "image/png"}
      ])

    assert render_upload(avatar, "../../evil.png") =~ "100%"

    html = view |> form("#kata-147-upload-form") |> render_submit()

    [_, path] = Regex.run(~r/File saved successfully to: <code[^>]*>([^<]+)</, html)
    on_exit(fn -> File.rm(path) end)

    assert has_element?(view, "#kata-147-flash-info", "File uploaded successfully to")
    assert Path.dirname(path) == "priv/static/uploads"
    assert Path.basename(path) =~ ~r/^liveview_lab_[0-9a-f-]{36}\.png$/
    refute path =~ "evil"
    assert File.read!(path) == "fake png bytes"
  end

  test "rejects files of the wrong type", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    avatar =
      file_input(view, "#kata-147-upload-form", :avatar, [
        %{name: "notes.txt", content: "hello", type: "text/plain"}
      ])

    assert {:error, [[_ref, :not_accepted]]} = render_upload(avatar, "notes.txt")
    assert render(view) =~ "File type not accepted"
  end

  test "cancelling an entry removes it", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    avatar =
      file_input(view, "#kata-147-upload-form", :avatar, [
        %{name: "pic.jpg", content: "jpg", type: "image/jpeg"}
      ])

    render_upload(avatar, "pic.jpg", 50)
    assert render(view) =~ "pic.jpg"

    view |> element("button[phx-click=cancel_upload]") |> render_click()
    refute render(view) =~ "pic.jpg"
  end
end
