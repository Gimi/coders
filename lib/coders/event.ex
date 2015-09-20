defmodule Coders.Event do
  @moduledoc """
  Struct module represents an application event.
  """

  defstruct id: nil, payload: nil
  @type t :: %__MODULE__{id: atom, payload: term}
end
