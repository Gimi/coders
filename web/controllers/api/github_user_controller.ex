defmodule Coders.API.GithubUserController do
  use Coders.Web, :controller

  alias Coders.GithubUser, as: User
  alias Coders.EventDispatcher

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
    user = User.changeset(params)
    profile = if user.valid?, do: Github.user(user.changes[:login])

    case profile do
      nil -> conn
             |> put_status(400)
             |> json(%{status: :error, message: "Could not find github user with #{user.changes[:login]}."})
      _   ->
        user = User.changeset(user, profile)
        Repo.insert! user

        EventDispatcher.fire(:github_user_added, user.changes)
        json conn, %{status: :ok, data: user.changes}
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.delete!(User, id) do
      0 -> send_resp conn, 404, ""
      n ->
        EventDispatcher.fire(:github_user_deleted, %{id: id})
        json conn, %{status: :ok, count: n}
    end
  end

  # we want to return JSON even when errors happen.
  defp set_json_content_type(conn, _), do: put_resp_content_type(conn, "application/json")
end
