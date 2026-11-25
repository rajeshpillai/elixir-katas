defmodule ElixirKatas.Pdf do
  @moduledoc """
  Renders HTML to PDF with headless Google Chrome or Chromium.

  Chrome is found on the `PATH`, or in `/Applications` on macOS. To use a
  specific binary, set:

      config :elixir_katas, :chrome_path, "/path/to/chrome"

  The HTML is printed as given, so callers must escape anything that came
  from a visitor before passing it in.
  """

  @executables ~w(google-chrome google-chrome-stable chromium chromium-browser chrome)
  @mac_apps [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium"
  ]

  @doc """
  Converts an HTML document to PDF bytes.

  Returns `{:ok, pdf_binary}`, or `{:error, reason}` when Chrome is missing
  or fails.
  """
  @spec from_html(String.t()) :: {:ok, binary()} | {:error, term()}
  def from_html(html) when is_binary(html) do
    with {:ok, chrome} <- chrome_path() do
      dir = Path.join(System.tmp_dir!(), "elixir_katas_pdf_#{System.unique_integer([:positive])}")
      File.mkdir_p!(dir)

      try do
        html_path = Path.join(dir, "document.html")
        pdf_path = Path.join(dir, "document.pdf")
        File.write!(html_path, html)

        args = [
          "--headless=new",
          "--disable-gpu",
          "--no-first-run",
          "--no-pdf-header-footer",
          # A throwaway profile keeps runs isolated from the user's Chrome.
          "--user-data-dir=#{Path.join(dir, "profile")}",
          "--print-to-pdf=#{pdf_path}",
          "file://#{html_path}"
        ]

        case System.cmd(chrome, args, stderr_to_stdout: true) do
          {_output, 0} ->
            case File.read(pdf_path) do
              {:ok, pdf} -> {:ok, pdf}
              {:error, _} -> {:error, :no_output}
            end

          {output, status} ->
            {:error, {:chrome_failed, status, output}}
        end
      after
        File.rm_rf(dir)
      end
    end
  end

  defp chrome_path do
    configured = Application.get_env(:elixir_katas, :chrome_path)

    found =
      cond do
        is_binary(configured) -> if File.exists?(configured), do: configured
        path = Enum.find_value(@executables, &System.find_executable/1) -> path
        path = Enum.find(@mac_apps, &File.exists?/1) -> path
        true -> nil
      end

    if found, do: {:ok, found}, else: {:error, :chrome_not_found}
  end
end
