defmodule Github.HTTP do
  @moduledoc """
  This module implements functions to handle github HTTP API calls,
  esp. makes it easier to handle github API responses.
  """

  require Logger

  use HTTPoison.Base

  @doc """
  Just like HTTPoison.Base.get/1, but ignores error cases (error or non 200 responses).
  For error cases, it will return the default value, which by default is nil.
  """
  @spec get_or(String.t, any) :: HTTPoison.Response.t | any
  def get_or(url, default \\ nil) do
    case get(url) do
      {:ok, resp = %HTTPoison.Response{status_code: 200}} -> resp
      {:ok, %HTTPoison.Response{status_code: code}}       ->
        Logger.error("GET #{url} returned #{code}.")
        default
      {:error, %HTTPoison.Error{reason: reason}}          ->
        Logger.error("GET #{url} failed with #{reason}.")
        default
    end
  end

  # we just want the body!
  def get_or!(url, default \\ nil) do
    case get_or(url, default) do
      %HTTPoison.Response{body: body} -> Poison.decode!(body)
      resp                            -> resp
    end
  end

  @doc """
  Get a collection reponse as a stream. If nothing returned,
  return an empty list.
  """
  @spec get_stream(String.t) :: Enumerable.t
  def get_stream(url) do
    case resp = get_or(url, []) do
      %HTTPoison.Response{} -> pagination_stream(resp)
      _                     -> resp
    end
  end

  @doc "Make a paginated resource, e.g. event, as a stream."
  @spec pagination_stream(HTTPoison.Response.t) :: Stream.t
  def pagination_stream(%HTTPoison.Response{body: body} = resp) do
    start_fn = fn -> {Poison.decode!(body), next_page_link(resp)} end

    next_fn =
      fn {items, next_link} ->
        case items do
          [head|tail] -> {[head], {tail, next_link}}
          _           ->
            case next_link do
              nil -> {:halt, {items, next_link}}
              _   ->
                resp = get!(next_link)
                case Poison.decode!(resp.body) do
                  [head|tail] -> {[head], {tail, next_page_link(resp)}}
                  _           -> {:halt, {[], nil}}
                end
            end
        end
      end

    end_fn = fn _ -> end

    Stream.resource(start_fn, next_fn, end_fn)
  end

  @doc false
  # Get the next page link from a pagenated response.
  defp next_page_link(%HTTPoison.Response{headers: headers}) do
    if links = List.keyfind(headers, "Link", 0) do
      link = elem(links, 1)
             |> String.split(", ")
             |> Stream.filter(&(String.ends_with?(&1, "rel=\"next\"")))
             |> Stream.map(&(hd(String.split(&1, ";", parts: 2))))
             |> Stream.map(&(&1 |> String.lstrip(?<) |> String.rstrip(?>)))
             |> Enum.take(1)
      case link do
        [url] -> url
        _     -> nil
      end
    end
  end

  @doc false
  defp process_url(url) do
    # url's may be returned by Github, those url's are absolute paths.
    case url do
      <<"https://", _::binary>> -> url
      _                         -> "https://api.github.com" <> url
    end
  end
end
