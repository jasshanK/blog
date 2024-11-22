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
