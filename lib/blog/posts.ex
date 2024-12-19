defmodule Blog.Posts do
  @content_url "https://raw.githubusercontent.com/jasshanK/blog_content/refs/heads/main/"
  @content_local "/home/jasshank/proj/blog/blog_content/"
  def get_page(file) do
    url = @content_url <> file |> String.to_charlist() |> IO.inspect()

    :inets.start()
    :ssl.start() 

    {:ok, {_header, _metadata, data}} = :httpc.request(:get, {url, []}, [], [])

    data
  end

  def get_page_local(file) do
    location = @content_local <> file
    File.read!(location)
  end 

  def get_posts() do
    posts = 
      get_page("meta/index.md")
      |> to_string() 
      |> String.split("\n\n")

    parse_posts(posts)
  end

  defp parse_posts(posts),
    do: do_parse_posts(posts, [])

  defp do_parse_posts([], acc), 
    do: {:ok, acc}
  defp do_parse_posts([head | tail], acc) do
    with fields <- String.split(head, "\n"), 
         path <- Enum.at(fields, 0),
         title <- Enum.at(fields, 1), 
         date <- Enum.at(fields, 2),
         summary <- Enum.at(fields, 3) do
      post = %{path: path, title: title, date: date, summary: summary}
      do_parse_posts(tail, [post | acc])
    else 
      _ -> {:error, :parsing_post_failed}
    end
  end

  defp add_id_to_heading({tag, attr, content, meta}, headings) do
    if String.at(tag, 0) == "h" do
        id_name = content 
        |> List.first() 
        |> String.downcase() 
        |> String.replace(" ", "-")

        headings = [{tag, id_name, content} | headings]

      {{tag, [{"id", id_name} | attr], nil, Map.put(meta, :headings, headings)}, headings} 
    else 
      {{tag, attr, nil, Map.put(meta, :headings, headings)}, headings}
    end
  end

  def get_html(post_path) do
    {:ok, ast, _} = get_page(post_path)
      |> to_string()
      |> EarmarkParser.as_ast(math: true)

    {ast, headings} = Earmark.Transform.map_ast_with(ast, [], &add_id_to_heading/2, true)

    ast = Earmark.Transform.map_ast(ast, fn {tag, attr, content, meta} -> 
      if tag == "img" do
        {_src_tag, img_path} = List.first(attr) 

        img_path = @content_url <> img_path

        [_, tail] = attr

        attr = [{"src", img_path}, tail]

        {tag, attr, content, meta}
      else 
        {tag, attr, content, meta}
      end
    end, true)

    ast = Earmark.Transform.map_ast(ast, 
      fn {"code", [{"class", "math-inline"}] = attr, content, meta} -> 
            node = {"code", attr, "$" <> List.first(content) <> "$" , meta}

            {:replace, node}
         {"code", [{"class", "math-display"}] = attr, content, meta} -> 
            node = {"code", attr, "$$" <> List.first(content) <> "$$" , meta}

            {:replace, node}
        {tag, attr, content, meta} -> {tag, attr, content, meta}
      end, 
    true)

    {Earmark.Transform.transform(ast) |> Phoenix.HTML.raw(), headings |> Enum.reverse()}
  end
end
