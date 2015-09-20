defmodule Coders.TaskServer do
  @doc """
  Run a task, with specific arguments.

  A task is a module which implements a run/1 function.
  """
  def run(task, args \\ []) do
    Task.Supervisor.async(__MODULE__, task, :run, args)
  end
end
