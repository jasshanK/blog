defmodule BlogWeb.HomeHTML do
  @moduledoc """
  This module contains pages rendered by HomeController.

  See the `page_html` directory for all templates available.
  """
  use BlogWeb, :html

  embed_templates "home_html/*"
end
