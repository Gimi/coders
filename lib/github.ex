defmodule Github do require Logger

  import Github.HTTP

  @typedoc "possible values of repository type."
  @type repo_type :: :all | :owner | :member

  @doc """
  Get a single user.
  If fail to call the API, return nil.
  """
  @spec user(String.t) :: map | nil
  def user(login) do
    get_or!("/users/#{login}", nil)
  end

  @doc """
  List events performed by a user.
  The return value could be a stream, if the API call successes.
  Or it could be an empty list, if anything wrong happens.
  """
  @spec user_events(String.t) :: Enumerable.t
  def user_events(login) do
    get_stream("/users/#{login}/events")
  end

  @doc """
  List public repositories for the specified user.
  """
  @spec user_repos(String.t, repo_type) :: Enumerable.t
  def user_repos(login, type \\ :owner) do
    get_stream("/users/#{login}/repos?type=#{type}")
  end
end
