defmodule Coders.Repo do
  @moduledoc """
  Maintain DB connection and implement functions which handle models.
  """

  use RethinkDB.Connection

  import RethinkDB.Query

  @typedoc "Response from RethinkDB."
  @type rethink_resp :: %RethinkDB.Record{} | %RethinkDB.Collection{} | %RethinkDB.Feed{} | %RethinkDB.Response{}

  @db_name Keyword.get(Application.get_env(:coders, Coders.Repo), :database, "coders")

  @doc """
  Insert a model's data into the model's table.
  """
  def create(model) do
    table_of(model) |> insert(model) |> run
  end

  @doc """
  Create the database.
  """
  def create_db, do: db_create(@db_name) |> run

  @doc """
  Drop the database.
  """
  def drop_db, do: db_drop(@db_name) |> run

  @doc """
  Create a table defined by the model Struct.
  """
  def create_table(model) do
    database
    |> table_create(table_name(model), %{primary_key: pk(model)})
    |> run
  end

  @doc """
  Return the db query.
  """
  defp database, do: db(@db_name)

  @doc false
  # Return the table name of a model.
  defp table_name(%{__struct__: mod}) when is_atom(mod), do: table_name(mod)  # model is a struct instance
  defp table_name(model) when is_atom(model),            do: model.table_name # model is a struct module

  @doc false
  # Return the primary key of a model.
  defp pk(%{__struct__: mod}) when is_atom(mod), do: pk(mod)           # model is a struct instance
  defp pk(model) when is_atom(model),            do: model.primary_key # model is a struct module

  @doc false
  # Return the table query of a model.
  defp table_of(model) do
    table(database, table_name(model))
  end
end
