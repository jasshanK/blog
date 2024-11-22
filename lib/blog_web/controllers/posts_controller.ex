defmodule BlogWeb.PostsController do
  use BlogWeb, :controller

  def posts(conn, %{"post_path" => post_path}) do
    {html, headings} = Blog.Posts.get_html(post_path)

    render(conn 
      |> assign(:content, html)
      |> assign(:headings, headings), :post)
  end

  def about(conn, _params) do
    {html, _headings} = Blog.Posts.get_html("meta/about.md")

    render(conn
      |> assign(:content, html), :about)
  end
end
