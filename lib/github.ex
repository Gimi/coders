defmodule Github do
  require Logger

  import Github.HTTP

  @doc """
  Get one user.
  If fail to call the API, return nil.
  """
  @spec user(String.t) :: map | nil
  def user(login) do
    case get_or("/users/#{login}", nil) do
      %HTTPoison.Response{body: body} -> Poison.decode!(body)
      resp                            -> resp
    end
  end

  @doc """
  List events performed by a user.
  The return value could be a stream, if the API call successes.
  Or it could be an empty list, if anything wrong happens.
  """
  @spec events(String.t) :: Enumerable.t
  def events(login) do
    case resp = get_or("/users/#{login}/events", []) do
      %HTTPoison.Response{} -> pagination_stream(resp)
      _                     -> resp
    end
  end
end
