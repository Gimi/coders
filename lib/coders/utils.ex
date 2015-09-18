defmodule Coders.Utils do
  @moduledoc "Functions don't fit into other modules."

  @doc "Poor man's pluralization function. It only appends 's' to the word for now."
  @spec pluralize(String.t) :: String.t
  def pluralize(word), do: word <> "s"
end
