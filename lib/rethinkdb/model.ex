defmodule RethinkDB.Model do
  defmacro __using__(_opt) do
    quote do
      @before_compile unquote(__MODULE__) # so models can override their table name or primary key

      @table_name to_string(__MODULE__) |> String.split(".") |> List.last |> Mix.Utils.underscore |> Coders.Utils.pluralize
      @primary_key :id
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def table_name,  do: @table_name
      def primary_key, do: @primary_key
    end
  end
end
