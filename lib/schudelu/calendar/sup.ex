defmodule Schudelu.Calendar.Sup do
  use Supervisor

  def start_link(_args\\nil) do Supervisor.start_link(__MODULE__, [], name: __MODULE__) end

  def init(_) do
    Supervisor.init(
      [
        {Registry, [name: Schudelu.Calendar.Registry, keys: :unique]},
        {DynamicSupervisor, strategy: :one_for_one, name: Schudelu.Calendar.Server.Sup}
      ],
      strategy: :one_for_one
    )
  end

  def debug(name) do
    [{pid, _}] = Registry.lookup(Schudelu.Calendar.Registry, name)
    GenServer.call(pid, :debug)
  end

  def debug_all do
    Registry.select(Schudelu.Calendar.Registry, [{{:"$1", :_, :_}, [], [:"$1"]}])
    |> Map.new(fn name ->
      {name, debug(name)}
    end)
  end
end
