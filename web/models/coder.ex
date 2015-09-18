defmodule Coders.Coder do
  @moduledoc """
  A Coder is a person who writes code! :D

  For now, we only support Github accounts.
  So a coder has a name, a github account, and a avatar_url to show his/her avatar.
  And the github account will be used as the primary key.
  """

  use Coders.Web, :model

  @primary_key :github

  defstruct github: nil, name: nil, avatar_url: nil
  @type t :: %__MODULE__{github: String.t, name: String.t, avatar_url: String.t}
end
