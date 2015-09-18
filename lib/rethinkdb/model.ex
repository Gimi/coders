defmodule RethinkDB.Model do
  defmacro __using__(_opt) do
    quote do
      use Ecto.Schema
    end
  end
end
