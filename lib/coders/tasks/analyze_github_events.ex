defmodule Coders.Task.AnalyzeGithubEvents do
  @moduledoc """
  Analyze a github user's activities by processing his/her events.
  """

  require Logger

  def run(%{login: login}) do
    #Github.events(user.login)
    Logger.info "Start to analyze events of #{login}"
    :ok
  end
end
