defmodule RethinkDB.Model do
  @moduledoc """
  Provides convenience functions for defining and working with models.
  
  ## Using

  When used, you can define `@required_fields` and `@optional_fields`
  attributes in your model, to specify which fields are required, and
  which are optional. Which is useful to generate the changeset.

  Also, a `changeset/2` function is defined to generate `Ecto.Changeset.t`.
  And it's overridable, which means, you can customize it, to and more
  validations.
  """

  defmacro __using__(_opt) do
    quote do
      # handy stuff from Ecto
      use Ecto.Schema
      import Ecto.Changeset

      # attributes
      Enum.each [:required_fields, :optional_fields], fn attr ->
        Module.register_attribute __MODULE__, attr, persist: true
        # set default value
        Module.put_attribute __MODULE__, attr, ~w()
      end

      @doc "Return Ecto.Changeset."
      def changeset(%{__struct__: _} = params), do: changeset(Map.from_struct(params))
      def changeset(params), do: changeset(struct(__MODULE__, []), params)
      def changeset(model, params) do
        model
        |> cast(params, required_fields, optional_fields)
      end

      defoverridable [changeset: 2]

      def required_fields() do
        __MODULE__.__info__(:attributes)
        |> List.keyfind(:required_fields, 0)
        |> elem(1)
      end

      def optional_fields() do
        __MODULE__.__info__(:attributes)
        |> List.keyfind(:optional_fields, 0)
        |> elem(1)
      end
    end
  end
end
