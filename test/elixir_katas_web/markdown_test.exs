defmodule ElixirKatasWeb.MarkdownTest do
  use ExUnit.Case, async: true

  alias ElixirKatasWeb.Markdown

  describe "safe_html/1" do
    test "escapes raw HTML instead of rendering it" do
      html = Markdown.safe_html(~s(<iframe src="file:///etc/passwd"></iframe>))

      refute html =~ "<iframe"
      assert html =~ "&lt;iframe"
    end

    test "drops javascript: links" do
      html = Markdown.safe_html("[click](javascript:alert(1))")

      refute html =~ "javascript:"
    end

    test "still renders Markdown" do
      assert Markdown.safe_html("**bold**") =~ "<strong>bold</strong>"
    end
  end

  describe "trusted_html/1" do
    test "keeps raw HTML used by the notes" do
      html = Markdown.trusted_html("<details><summary>More</summary>\n\nHidden\n\n</details>")

      assert html =~ "<details>"
      assert html =~ "<summary>More</summary>"
    end

    test "renders GFM tables, strikethrough and code fences" do
      md = """
      | A | B |
      |---|---|
      | 1 | 2 |

      ~~old~~

      ```elixir
      IO.puts("<b>not html</b>")
      ```
      """

      html = Markdown.trusted_html(md)

      assert html =~ "<table>"
      assert html =~ "<del>old</del>"
      assert html =~ ~s(<code class="language-elixir">)
      assert html =~ "&lt;b&gt;not html&lt;/b&gt;"
    end
  end
end
