defmodule Coders.PageController do
  use Coders.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
