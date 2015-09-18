defmodule Coders.API.CoderController do
  use Coders.Web, :controller

  def create(conn, params) do
    json conn, %{status: :ok, params: params}
  end
end
