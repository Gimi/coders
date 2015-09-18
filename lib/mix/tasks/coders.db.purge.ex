defmodule Mix.Tasks.Coders.Db.Purge do
  use Mix.Task
  use Coders.Mix.DB

  @shortdoc "Destroy the DB used by Coders app!"

  @moduledoc """
  Drop the database for the application. Use with carefulness!

  ## Example

      mix coders.db.purge
  """

  @doc false
  def run(_args) do
    connect_db

    info "Going to drop DB ..."
    show_result(drop_db)

    :ok
  end
end
