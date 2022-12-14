defmodule Schudelu.Calendar.Server do
  @moduledoc """
  Calendar server.

  Handled event types:
    - delay

  To handle event types:
    - date
  """
  use GenServer

  def child_spec(name) do
    %{
      id: {__MODULE__, name},
      start: {__MODULE__, :start_link, [name]}
    }
  end

  def start_link(name), do: GenServer.start_link(__MODULE__, name, name: {:via, Registry, {Schudelu.Calendar.Registry, name}})

  def init(name) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Starting #{inspect name}")
    {:ok, %{name: name, events: [], state: :stopped, entry_points: [], subscribed: %{}}, {:continue, :load}}
  end

  def handle_continue(:load, state) do #TODO
    events = %{}
    {:noreply, %{state|events: events}}
  end


  def handle_call(message, from, state) do
    case calendar_call(message, from, state) do
      {:reply, reply, new_state} ->
        if state != new_state, do: to_subscribers({:new_state, new_state}, new_state.subscribed)
        {:reply, reply, new_state}
      {:reply, reply, new_state, timeout} ->
        if state != new_state, do: to_subscribers({:new_state, new_state}, new_state.subscribed)
        {:reply, reply, new_state, timeout}
      {:noreply, new_state} ->
        if state != new_state, do: to_subscribers({:new_state, new_state}, new_state.subscribed)
        {:noreply, new_state}
      {:noreply, new_state, timeout} ->
        if state != new_state, do: to_subscribers({:new_state, new_state}, new_state.subscribed)
        {:noreply, new_state, timeout}
      {:stop, reason, reply, new_state} ->
        if state != new_state, do: to_subscribers({:stopped, new_state.name}, new_state.subscribed) #Should be called only if the calendar is deleted
        {:stop, reason, reply, new_state}
      {:stop, reason, new_state} ->
        if state != new_state, do: to_subscribers({:stopped, new_state.name}, new_state.subscribed) #Should be called only if the calendar is deleted
        {:stop, reason, new_state}
    end
  end
  def calendar_call({:add_entry_point, event_id}, _from, state) do
    case Map.has_key?(state.events, event_id) do
      true -> {:reply, :ok, %{state| entry_points: Enum.uniq([event_id|state.entry_points])}}
      false -> {:reply, {:error, :event_not_found}, state}
    end
  end
  def calendar_call({:schedule, event}, _from, state) do
    {id, state} = add_event(state, event)
    {:reply, {:ok, id}, state}
  end
  def calendar_call(:events, _from, state) do
    {:reply, state.events, state}
  end
  def calendar_call({:start_events,events_ids}, _from, state) do
    {:reply, :ok, do_start(state, events_ids)}
  end
  def calendar_call({:edit, event_id, new_event}, _from, %{events: events} = state) do
    case events do
      %{^event_id => event} ->
        case edit_event(event_id, event, new_event) do
          {:ok, new_event} ->
            {:reply, :ok, %{state|events: Map.put(events, event_id, new_event)}}
          {:error, reason} -> {:reply, reason, state}
        end
      _ -> {:reply, :event_not_found, state}
    end
  end
  def calendar_call(:debug, _from,  state) do
    {:reply, state, state}
  end
  def calendar_call({:subscribe, name}, {pid, _} = _from, state) do # The caller pid is now subscribe to the calendar event message
    {:reply, :ok, %{state|subscribed: Map.put(state.subscribed, name, pid)}}
  end

  def handle_info(message, state) do
    case calendar_info(message, state) do
      {:noreply, new_state} ->
        if state != new_state, do: to_subscribers({:new_state, new_state}, new_state.subscribed)
        {:noreply, new_state}
      {:noreply, new_state, timeout} ->
        if state != new_state, do: to_subscribers({:new_state, new_state}, new_state.subscribed)
        {:noreply, new_state, timeout}
      {:stop, reason, new_state} ->
        if state != new_state, do: to_subscribers({:stopped, new_state.name}, new_state.subscribed) #Should be called only if the calendar is deleted
        {:stop, reason, new_state}
    end
  end
  def calendar_info({:event_finished, event_id}, %{events: events} = state) do
    case events do
      %{^event_id => event} ->
        {:noreply, terminate_event(event_id, event, state)}
      _ ->
        {:noreply, state}
    end
  end

  def process_id(name) do
    [{pid, _}] = Registry.lookup(Schudelu.Calendar.Registry, name)
    pid
  end

  def add_event(state, event) do
    id = generate_id(state)
    {id, %{state|events: Map.put(state.events, id, %{state: :idle, event: event})}}
  end

  def generate_id(state) do
    state.events
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.max(fn -> 0 end)
    |> Kernel.+(1)
  end

  def find_entry_points(state) do
    principal_entry_points = state.entry_points
    principal_entry_points
  end

  def do_start(state, events_ids) do
    state
    |> Map.update!(:events, fn events -> Map.new(events, fn {event_id, event} -> {event_id, may_start_event(event_id, event, state, events_ids)} end) end)
    |> Map.put(:state, :active)
  end

  def may_start_event(event_id, event, _state, event_ids) do
    if event_id in event_ids do
      start_event(event_id, event)
    else
      event
    end
  end

  # Hanlde start on delay events
  def start_event(event_id, %{event: %{desc: %{type: :delay, delay: delay}}, state: :idle} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Starting event #{inspect event_id} also named: #{inspect event.event.name}")
    timer_ref = Process.send_after(self(), {:event_finished, event_id}, delay)
    %{event|state: {:started, timer_ref}}
  end
  def start_event(event_id, %{event: %{desc: %{type: :delay, delay: _}}, state: {:paused, rem_time}} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Restarting event #{inspect event_id} also named: #{inspect event.event.name}")
    timer_ref = Process.send_after(self(), {:event_finished, event_id}, rem_time)
    %{event|state: {:started, timer_ref}}
  end
  def start_event(event_id, %{event: %{desc: %{type: :manual}}, state: :idle} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Starting event #{inspect event_id} also named: #{inspect event.event.name}")
    %{event|state: {:started, nil}}
  end

  # Handle pause on delay events
  def pause_event(event_id, %{event: %{desc: %{type: :delay, delay: _}}, state: {:started, timer_ref}} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Pausing event #{inspect event_id} also named: #{inspect event.event.name}")
    rem_time = Process.cancel_timer(timer_ref)
    %{event|state: {:paused, rem_time}}
  end

  # Handle cancel on delay events
  def cancel_event(event_id, %{event: %{desc: %{type: :delay, delay: _}}, state: {:started, timer_ref}} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Canceling event #{inspect event_id} also named: #{inspect event.event.name}")
    _ = Process.cancel_timer(timer_ref)
    %{event|state: :idle}
  end
  def cancel_event(event_id, %{event: %{desc: %{type: :delay, delay: _}}, state: {:paused, _}} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Canceling event #{inspect event_id} also named: #{inspect event.event.name}")
    %{event|state: :idle}
  end
  def cancel_event(event_id, %{event: %{event: %{desc: %{type: :manual}}, state: {:started, _}}} = event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Canceling event #{inspect event_id} also named: #{inspect event.event.name}")
    %{event|state: :idle}
  end


  def terminate_event(event_id, %{event: %{desc: %{type: :delay, delay: _}}, state: {:started, _}} = event, state) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Terminating event #{inspect event_id} also named: #{inspect event.event.name}")
    do_terminate_event(event_id, event, state)
  end
  def terminate_event(event_id, %{event: %{desc: %{type: :manual}}, state: {:started, _}} = event, state) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Terminating event #{inspect event_id} also named: #{inspect event.event.name}")
    do_terminate_event(event_id, event, state)
  end

  def do_terminate_event(event_id, event, state) do
    affected_events = on_finish(event, state)
    events = state.events
             |> Map.merge(%{event_id => %{event|state: :idle}})
             |> Map.merge(affected_events)
    Map.put(state, :events, events)
    |> may_stop()
  end

  def may_stop(state) do
    if Enum.all?(state.events, fn {_, %{state: state}} -> state == :idle end) do
      Map.put(state, :state, :stopped)
    else
      state
    end
  end

  def on_finish(%{event: %{on_finish: on_finish}}, state) do
    next_events_ids = Map.get(on_finish, :next_events , [])

    next_events_ids
    |> Map.new(fn event_id -> {event_id, start_event(event_id, state.events[event_id])} end)
  end

  def edit_event(event_id,  %{event: %{desc: %{type: :delay, delay: _}}, state: :idle} = event, new_event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Editing event #{inspect event_id} also named: #{inspect event.event.name}")

    {:ok, %{event| event: new_event}}
  end
  def edit_event(event_id,  %{event: %{desc: %{type: :delay, delay: _}}, state: {:started, _}} = event, _new_event) do
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Refusing editing event #{inspect event_id} also named: #{inspect event.event.name}")
    {:error, :started}
  end
  def edit_event(event_id,  %{event: %{desc: %{type: :delay, delay: _}}, state: {:paused, _}} = event, _new_event) do 
    require Logger
    Logger.debug("[#{inspect __MODULE__}] Refusing editing event #{inspect event_id} also named: #{inspect event.event.name}")
    {:error, :started}
  end

  def to_subscribers(message, subscribers) do
    subscribers
    |> Enum.each(fn {_name, pid} -> send(pid, message) end)
  end
end
