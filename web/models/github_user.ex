defmodule Coders.GithubUser do
  @moduledoc """
  Represents Github users.

  It only contains fields those we care about.
  """

  use Coders.Web, :model

  @primary_key {:login, :string, autogenerate: false}

  schema "github_users" do
    field :name,       :string
    field :avatar_url, :string
    field :status,     :string
    field :created_at, :string # Ecto.DateTime - `rethinkdb` can't handle this
    field :updated_at, :string # Ecto.DateTime
    field :watched_at, :string # Ecto.DateTime
  end


  @required_fields ~w(login)
  @optional_fields ~w(name avatar_url status created_at updated_at)

  @status %{
    new: "new",
    updated: "updated"
  }

  @doc """
  Create a new Coder, and set some fields with their default values.
  """
  def new, do: new(%{})
  def new(attrs) do
    struct __MODULE__, Map.merge(%{status: @status[:new]}, attrs)
  end

  @doc"""
  Transfer a user from current status to a new status.
  """
  def transfer(model, status), do: changeset(model, %{model | status: @status[status]})

  @doc false
  # override
  def changeset(model, params) do
    super(model, params)
    |> validate_format(:avatar_url, ~r(^https?://))
    |> validate_change(:created_at, &validate_time(&1, &2))
    |> validate_change(:updated_at, &validate_time(&1, &2))
    |> add_watched_at
  end

  # TODO use `RethinkDB.Pseudotypes.Time`
  defp validate_time(k, v) do
    case Ecto.DateTime.cast(v) do
      {:ok, _} -> []
      :error   -> [k, "is not a time"]
    end
  end

  defp add_watched_at(%Ecto.Changeset{model: model, changes: changes} = changeset) do
    if is_nil(model.watched_at) and is_nil(changes[:watched_at]) do
      %{changeset | changes: Map.put(changes, :watched_at, Ecto.DateTime.to_string(Ecto.DateTime.utc))}
    else
      changeset
    end
  end
end
