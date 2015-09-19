defmodule Coders.API.GithubUserController do
  use Coders.Web, :controller

  alias Coders.GithubUser, as: User

  plug :set_json_content_type # move this to a utils module when we have more API modules

  def index(conn, _params) do
    users = Repo.get_all!(User)
    json conn, %{status: :ok, data: users, count: length(users)}
  end

  def show(conn, %{"id" => id}) do
    case Repo.get!(User, id) do
      nil  -> send_resp conn, 404, ""
      user -> json conn, %{status: :ok, data: user}
    end
  end

  def create(conn, params) do
    login = User.changeset(params) |> Repo.insert!
    user  = Repo.get!(User, login)

    #Coders.GithubUserWatcher.notify(:user_added, res)
    json conn, %{status: :ok, data: user}
  end

  def delete(conn, %{"id" => id}) do
    case Repo.delete!(User, id) do
      0 -> send_resp conn, 404, ""
      n -> json conn, %{status: :ok, count: n}
    end
  end

  # we want to return JSON even when errors happen.
  defp set_json_content_type(conn, _), do: put_resp_content_type(conn, "application/json")
end
