defmodule Coders.Mix.DB do
  @moduledoc """
  Helper functions for DB related tasks.
  """

  defmacro __using__(_opt) do
    quote do
      import Coders.Repo
      import unquote(__MODULE__)
    end
  end

  @doc """
  Connect the repo to DB.
  """
  def connect_db() do
    # make this function safe to be called multiple times
    unless Process.whereis(Coders.Repo) do
      Coders.Repo.connect Application.get_env(:coders, Coders.Repo)
    end
  end

  @doc """
  Output proper message to shell according to the response from RethinkDB.
  """
  def show_result(%RethinkDB.Record{}), do: info("Done.")
  def show_result(%RethinkDB.Response{data: %{"r" => msg}}), do: info(Enum.join(msg, "; "))

  @doc """
  Shortcut to Mix.shell.info.
  """
  def info(msg), do: Mix.shell.info(msg)
end
