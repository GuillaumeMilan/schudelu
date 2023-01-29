defmodule SchudeluWeb.EventLive.SummaryComponent do
  use SchudeluWeb, :live_component

  def actions(%{event: %{state: {:paused, _}, event: %{type: :delay}}} = assigns) do
    ~H"""
    <span><button phx-click="start-event" phx-target={@myself}>Start</button></span>
    """
  end
  def actions(%{event: %{state: {:started, _}, event: %{type: :delay}}} = assigns) do
    ~H"""
    <span><button phx-click="pause-event" phx-target={@myself}>Pause</button></span>
    """
  end
  def actions(assigns) do
    require Logger
    Logger.debug("Assigns are #{inspect assigns}")
    Logger.debug("event state is #{inspect assigns.event.state}")
    Logger.debug("event type is #{inspect assigns.event.event.type}")
    nil
  end

  @impl true
  def handle_event("start-event", _params, socket) do
    Schudelu.Calendar.start_events(socket.assigns.calendar.id, [socket.assigns.event.event.id])
    {:noreply, socket}
  end
  def handle_event("pause-event", _params, socket) do
    Schudelu.Calendar.pause_event(socket.assigns.calendar.id, socket.assigns.event.event.id)
    {:noreply, socket}
  end
  def handle_event("finish-event", _params, socket) do
    Schudelu.Calendar.finish_event(socket.assigns.calendar.id, socket.assigns.event.event.id)
    {:noreply, socket}
  end
  def handle_event("cancel-event", _params, socket) do
    Schudelu.Calendar.cancel_event(socket.assigns.calendar.id, socket.assigns.event.event.id)
    {:noreply, socket}
  end
  def handle_event(message, params, socket) do
    require Logger
    msg = """
    [#{inspect __MODULE__}] Unexpected message received
    Message: #{inspect message}
    Params: #{inspect params}
    """
    Logger.warn(msg)
    {:noreply, socket}
  end
end
