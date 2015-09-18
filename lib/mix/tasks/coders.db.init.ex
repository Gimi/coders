defmodule Mix.Tasks.Coders.Db.Init do
  use Mix.Task
  use Coders.Mix.DB

  @shortdoc "Initialize DB for Coders app."

  @moduledoc """
  Initialize the backend storage for the application.

  The initialization includes:
  * create db
  * create tables for each model

  It's possible to drop the existing DB before the initialization by passing the switch --purge.

  ## Example

      mix coders.db.init
      mix coders.db.init --purge

  Unknown switchs will be ignored.
  """

  @doc false
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [purge: :boolean])
    if Keyword.get(opts, :purge, false), do: Mix.Task.run(Coders.Db.Purge)

    connect_db

    info "Going to create DB ..."
    show_result(create_db)

    info "Going to create tables ..."
    show_result(create_table(Coders.Coder))

    :ok
  end
end
