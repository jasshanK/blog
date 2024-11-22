defmodule BlogWeb.HomeController do
  use BlogWeb, :controller

  def home(conn, _params) do
    {:ok, posts} = Blog.Posts.get_posts()

    conn = conn 
      |> assign(:posts, posts)

    render(conn, :home)
  end
end
