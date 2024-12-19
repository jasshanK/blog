defmodule BlogWeb.PostsHTML do
  use BlogWeb, :html
   
  def post(assigns) do
    ~H"""
    <div class="middle_buffer">
      <section class="post_section">
        <%= @content %>
      </section>
    </div>
    <div class="right_buffer">
      <nav id="post_toc">
        <h3>Content</h3>
        <ul>
          <%= for {tag, heading, content} <- @headings do%>
            <li><a href={"#" <> heading} class={tag}><%= content %></a></li>
            <% end %>
        </ul>
      </nav>
    </div>
    <script>
      MathJax = {
        tex: {
          inlineMath: [['$', '$']],
          displayMath: [['$$', '$$']]
        },
        options: {
          processHtmlClass: "math-inline|math-display"
        },
      };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
    """
  end

  def about(assigns) do
    ~H"""
    <div class="middle_buffer">
      <section class="post_section">
        <%= @content %>
      </section>
    </div>
    """
  end
end
