defmodule Coders.Coder do
  @moduledoc """
  A Coder is a person who writes code! :D

  For now, we only support Github accounts.
  So a coder has a name, a github account, and a avatar_url to show his/her avatar.
  And the github account will be used as the primary key.
  """

  use Coders.Web, :model

  @primary_key {:github, :string, autogenerate: false}

  schema "coders" do
    field :name,       :string
    field :avatar_url, :string
  end


  @required_fields ~w(:github, :name)
  @optional_fields ~w(:avatar_url)
end
