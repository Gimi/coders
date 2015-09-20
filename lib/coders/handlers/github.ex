defmodule Coders.Handler.Github do
  use GenEvent

  @tasks [
    Coders.Task.AnalyzeGithubEvents,
    Coders.Task.AnalyzeGithubRepos
  ]

  # callbacks

  @doc false
  def init(_arg) do
    {:ok, :ok}
  end

  @doc false
  def handle_event(%Coders.Event{id: :github_user_added, payload: user}, :ok) do
    Enum.each @tasks, &Coders.TaskServer.run(&1, [user])
    {:ok, :ok}
  end

  @doc false
  def handle_event(_, :ok), do: {:ok, :ok}

  @doc false
  # ignore all other events
  def handle_info(_, :ok), do: {:ok, :ok}
end
