defmodule Coders.Task.AnalyzeGithubRepos do
  @moduledoc """
  Analyze repos of a github user.

  We can find many interesting facts from repos data of a user.
  This module is just a simple example shows how to do it.
  """

  require Logger

  @doc false
  # callback
  def run(%{login: login}) do
    Logger.info "Start to analyze repos for #{login}."

    Github.user_repos(login)
    |> Enum.reduce(%{languages: [], repos: []}, fn repo, %{languages: langs, repos: repos} ->
      %{languages: process_lang(langs, repo), repos: process_repos(repos, repo)}
    end)
    |> analyze
    |> save_results(login)

    Logger.info "Successfully analyzed repos for #{login}."
    :ok
  end

  defp process_lang(langs, repo) when is_list(langs) do
    case repo["language"] do
      nil -> langs
      lang ->
        key = String.to_atom lang
        langs = Keyword.put_new(langs, key, 0)
        count = Keyword.get(langs, key)
        Keyword.put(langs, key, count + 1)
    end
  end

  defp process_repos(repos, repo) when is_list(repos) do
    [Map.take(repo, ["name", "html_url", "watchers_count", "forks_count", "stargazers_count", "size"]) | repos]
  end

  defp analyze(%{repos: []}), do: %{}
  defp analyze(%{languages: langs, repos: repos}) do
    %{
      favorite_language: favorite_lang(langs),
      most_wanted:  max_by(repos, "watchers_count"),
      most_forked:  max_by(repos, "forks_count"),
      most_starred: max_by(repos, "stargazers_count"),
      biggest:      max_by(repos, "size")
    }
  end

  defp favorite_lang([]), do: nil
  defp favorite_lang(langs) when is_list(langs) do
    Enum.max_by(langs, &(elem(&1, 1))) |> elem(0)
  end

  defp max_by(repos, key) do
    Enum.max_by(repos, &(&1[key])) |> Map.take(["name", "html_url", key])
  end

  defp save_results(results, login) do
    Coders.Repo.update(Coders.GithubUser, login, %{"repos" => results})
  end
end
