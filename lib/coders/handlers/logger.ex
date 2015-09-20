defmodule Coders.Handler.Logger do
  use GenEvent

  require Logger

  # callbacks

  @doc false
  def init(_args) do
    {:ok, :ok}
  end

  @doc false
  def handle_event(%Coders.Event{id: id, payload: payload}, :ok) do
    Logger.info("Event #{id} - #{inspect payload}")
    {:ok, :ok}
  end

  @doc false
  def handle_info(_, :ok) do
    {:ok, :ok}
  end
end
