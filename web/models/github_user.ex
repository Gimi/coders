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
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
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

  @doc """
  Retrieve data for the user from Github.
  """
  def pop_fields(%{github: github} = model) do
    Map.merge(model, %{github: github})
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
  end
end
