# All exceptions are defined here until we want them to be more organized.

defmodule Coders.InvalidData do
  @moduledoc """
  This exception will be raised when invalid data is tried to be stored in DB.
  """

  defexception [:message, :model, :errors, plug_status: 400]

  def exception(%Ecto.Changeset{model: %{__struct__: model}, errors: errors}) do
    msg = "Could not create / update #{model} due to invalid data: #{inspect errors}"
    %Coders.InvalidData{message: msg, model: model, errors: errors}
  end

  def exception(msg) do
    %Coders.InvalidData{message: msg, model: nil, errors: nil}
  end
end
