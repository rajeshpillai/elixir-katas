defmodule ElixirKatasWeb.Markdown do
  @moduledoc """
  Markdown rendering for the app, backed by MDEx.

  There are two entry points, and the choice matters for security:

    * `trusted_html/1` keeps raw HTML. Use it only for Markdown that ships
      with the app, such as the kata notes in `notes/`.
    * `safe_html/1` escapes raw HTML and drops dangerous links. Use it for
      anything a visitor can send.
  """

  # Earmark, the previous renderer, enabled these by default, so notes keep
  # rendering the same way.
  @extension [table: true, strikethrough: true, autolink: true, tasklist: true]
  @parse [smart: true]

  @doc "Renders Markdown from a trusted source. Raw HTML is kept."
  @spec trusted_html(String.t()) :: String.t()
  def trusted_html(markdown) when is_binary(markdown) do
    MDEx.to_html!(markdown, extension: @extension, parse: @parse, render: [unsafe: true])
  end

  @doc "Renders untrusted Markdown. Raw HTML is shown as text, not run."
  @spec safe_html(String.t()) :: String.t()
  def safe_html(markdown) when is_binary(markdown) do
    MDEx.to_html!(markdown,
      extension: @extension,
      parse: @parse,
      render: [unsafe: false, escape: true]
    )
  end
end
