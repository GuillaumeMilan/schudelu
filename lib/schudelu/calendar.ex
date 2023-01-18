defmodule Schudelu.Calendar do

  def create(_name) do
    #TODO
  end

  def start(name) do
    DynamicSupervisor.start_child(Schudelu.Calendar.Server.Sup, {Schudelu.Calendar.Server, name})
  end

  def schedule(calendar, event) do
    call(calendar, {:schedule, event})
  end

  def edit(calendar, event_id, event) do
    call(calendar, {:edit, event_id, event})
  end

  def events(calendar) do
    call(calendar, :events)
  end

  def entry_point(calendar, event_id) do
    call(calendar, {:add_entry_point, event_id})
  end

  def start_events(calendar, events_ids) do
    call(calendar, {:start_events, events_ids})
  end

  def finish_event(calendar, event_id) do
    do_send(calendar, {:event_finished, event_id})
  end

  def pause_event(calendar, event_id) do
    do_send(calendar, {:event_pause, event_id})
  end

  def cancel_event(calendar, event_id) do
    do_send(calendar, {:event_cancel, event_id})
  end

  def subscribe(calendar, subscribe_as) do
    call(calendar, {:subscribe, subscribe_as})
  end

  def call(calendar, msg) do
    GenServer.call(Schudelu.Calendar.Server.process_id(calendar), msg)
  end

  def do_send(calendar, msg) do
    Process.send(Schudelu.Calendar.Server.process_id(calendar), msg, [])
  end

  def list do
    Registry.select(Schudelu.Calendar.Registry, [{{:"$1", :_, :_}, [], [:"$1"]}])
  end

  def is_started?(id) do
    case Registry.lookup(Schudelu.Calendar.Registry, id) do
      [] -> false
      [_] -> true
    end
  end
end
