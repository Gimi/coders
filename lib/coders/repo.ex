defmodule Coders.Repo do
  @moduledoc """
  Maintain DB connection and implement functions which handle models.

  DB most functions have two forms, the normal form, and the band form (
  with "!" suffix). Usually, the normal form will return `#{__MODULE__}.rethink_resp`,
  while the bang form will return the data directly, or raise errors if error happen.

  TODO

  Implementing all these functions is a bit crazy here.
  We should define a `run` macro. With which, we can do things like:

      Repo.run(with: User), do: get(id)
      Repo.run(with: User), do: get_all([id1, id2, ..., idN]) |> delete
      Repo.run(with: User), do: map(...) |> group(...)

  Without this `run` macro, we lost lots of flexibilities from REQL.
  """

  use RethinkDB.Connection

  alias RethinkDB.Query,  as: Q

  @typedoc "Response from RethinkDB."
  @type rethink_resp :: %RethinkDB.Record{} | %RethinkDB.Collection{} | %RethinkDB.Feed{} | %RethinkDB.Response{}

  @db_name Keyword.get(Application.get_env(:coders, Coders.Repo), :database, "coders")

  @doc """
  Insert a model's data into the model's table.
  """
  @spec insert(Ecto.Changeset.t) :: rethink_resp
  def insert(%Ecto.Changeset{model: model, changes: changes, valid?: true}) do
    changes = Map.merge(%{created_at: Ecto.DateTime.to_string(Ecto.DateTime.utc)}, changes)
    table_of(model) |> Q.insert(changes) |> run
  end

  def insert(%Ecto.Changeset{valid?: false} = cs) do
    raise Coders.InvalidData, cs
  end

  def insert!(changeset) do
    case process_rethinkdb_record(insert(changeset), "generated_keys") do
      true -> id(changeset)
      keys -> keys
    end
  end

  @doc """
  Update a record of the model.
  """
  def update(model, id, updates) when is_atom(model) and is_map(updates) do
    table_of(model) |> Q.get(id) |> Q.update(updates) |> run
  end

  @doc """
  Delete a record of the model by ID (primary key).
  """
  def delete(model, id) when is_atom(model) and is_list(id) do
    table_of(model) |> Q.get_all(id) |> Q.delete |> run
  end

  def delete(model, id) when is_atom(model) do
    delete(model, [id])
  end

  def delete!(model, id) when is_atom(model) do
    delete(model, id) |> process_rethinkdb_record("deleted")
  end

  @doc """
  Delete all records of a model.
  """
  def delete_all(model) when is_atom(model) do
    table_of(model) |> Q.delete |> run
  end

  def delete_all!(model) when is_atom(model) do
    delete_all(model) |> process_rethinkdb_record("deleted")
  end

  @doc """
  Get all records of a model from DB.
  """
  def get_all(model) do
    table_of(model) |> run
  end

  def get_all!(model) do
    case get_all(model) do
      %RethinkDB.Collection{data: data} -> data
      _                                 -> raise "Could not read data from DB." # TODO should do better exception
    end
  end

  @doc """
  Get a record of a model by the primary key.
  """
  def get(model, id) when is_list(id) do
    table_of(model) |> Q.get_all(id) |> run
  end

  def get(model, id), do: get(model, [id])

  def get!(model, id) do
    case get(model, id) do
      %RethinkDB.Collection{data: []} -> nil
      %RethinkDB.Collection{data: [data]} -> data
      %RethinkDB.Collection{data: data}   -> data
      error                               -> raise "Could not read data from DB. #{inspect error}" # TODO should do better exception
    end
  end

  @doc """
  Create the database.
  """
  def create_db, do: Q.db_create(@db_name) |> run

  @doc """
  Drop the database.
  """
  def drop_db, do: Q.db_drop(@db_name) |> run

  @doc """
  Create a table defined by the model Struct.
  """
  def create_table(model) do
    p_k = case pk(model) do
      [k]  -> k
      keys -> keys
    end

    db
    |> Q.table_create(table_name(model), %{primary_key: p_k})
    |> run
  end

  @doc false
  # Return the db query.
  defp db, do: Q.db(@db_name)

  @doc false
  # Return the table name of a model or a model's changeset.
  defp table_name(model_or_changeset)
  defp table_name(%Ecto.Changeset{model: model}),        do: table_name(model.__struct__)
  defp table_name(%{__struct__: mod}) when is_atom(mod), do: table_name(mod)
  defp table_name(model) when is_atom(model),            do: model.__schema__(:source)

  @doc false
  # Return the primary key of a model.
  defp pk(%{__struct__: mod}) when is_atom(mod), do: pk(mod)
  defp pk(model) when is_atom(model) do
    model.__schema__(:primary_key)
  end

  @doc false
  # Return the table query of a model.
  defp table_of(model_or_changeset) do
    Q.table(db, table_name(model_or_changeset))
  end

  @doc false
  # Retrieve the value of the primary key of a model or changeset.
  defp id(%Ecto.Changeset{model: model, changes: changes}) do
    Enum.reduce pk(model), [], fn k, acc ->
      [changes[k] | acc]
    end
  end

  defp id(model) do
    Enum.reduce pk(model), [], fn k, acc ->
      [model[k] | acc]
    end
  end

  defp process_rethinkdb_record(resp, concern \\ :empty) do
    case resp do
      %RethinkDB.Record{data: %{"errors" => 0, ^concern => keys}} -> keys
      %RethinkDB.Record{data: %{"errors" => 0}} -> true
      %RethinkDB.Record{data: %{"first_error" => error}} -> raise Coders.InvalidData, error
    end
  end
end
