defmodule Coders.EventDispatcher do
  @moduledoc """
  Dispatch application events.
  """

  use Supervisor

  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @event_manager Coders.EventManager

  @default_handlers [Coders.Handler.Logger]

  def init(:ok) do
    Logger.info "Starting #{__MODULE__} ..."

    children = [
      worker(GenEvent, [[name: @event_manager]]),
      worker(Task, [&subscribe_handlers/0], restart: :temporary) # it depends on the event manager
    ]

    supervise(children, strategy: :one_for_one)
  end

  @doc """
  Fire an event. See `Coders.Event` for more details.
  """
  @spec fire(atom, term) :: :ok
  def fire(id, payload \\ nil) when is_atom(id) do
    GenEvent.sync_notify(@event_manager, %Coders.Event{id: id, payload: payload})
  end

  # Add handlers to event manager
  defp subscribe_handlers() do
    Application.get_env(:coders, __MODULE__, %{})
    |> Keyword.get(:handlers, @default_handlers)
    |> Enum.each(fn
      [m|a] ->
        GenEvent.add_handler(@event_manager, m, a)
        Logger.info "Subscribed event handler #{m} with #{a}."
      m ->
        GenEvent.add_handler(@event_manager, m, [])
        Logger.info "Subscribed event handler #{m}."
    end)
  end
end
