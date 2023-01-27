defmodule SchudeluWeb.CalendarLive.Show do
  use SchudeluWeb, :live_view

  alias Schudelu.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    require Logger
    Logger.debug("Socket assigns: #{inspect socket.assigns}")
    calendar = Tools.get_calendar!(id)
    case Schudelu.Calendar.start(calendar.id) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
    Schudelu.Calendar.subscribe(calendar.id, socket.id)

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:calendar, calendar)
      |> ensure_assign(:calendar_state, %{})
      |> ensure_assign(:debug_mode, false)
    }
  end


  @impl true
  def handle_event("start-calendar", _params, socket) do
    Schudelu.Calendar.start_events(socket.calendar.id, socket.calendar_state.entry_points)
    {:noreply, socket}
  end
  def handle_event("click-debug-toggle", _params, socket) do
    {
      :noreply,
      socket
      |> assign(:debug_mode, !socket.assigns.debug_mode)
    }
  end
  def handle_event("event-finished-"<>id, _params, socket) do
    Schudelu.Calendar.finish_event(socket.assigns.calendar.id, String.to_integer(id))
    {:noreply, socket}
  end
  def handle_event("event-pause-"<>id, _params, socket) do
    Schudelu.Calendar.pause_event(socket.assigns.calendar.id, String.to_integer(id))
    {:noreply, socket}
  end
  def handle_event("event-cancel-"<>id, _params, socket) do
    Schudelu.Calendar.cancel_event(socket.assigns.calendar.id, String.to_integer(id))
    {:noreply, socket}
  end
  def handle_event("event-start-"<>id, _params, socket) do
    Schudelu.Calendar.start_events(socket.assigns.calendar.id, [String.to_integer(id)])
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
  def handle_info({:new_state, %{name: calendar_name} = new_state}, socket) do
    require Logger
    Logger.debug("Socket received message from calendar #{inspect calendar_name}")# with new calendar state: \n#{inspect new_state, pretty: true}")
    {
      :noreply,
      socket
      |> assign(:calendar_state, new_state)
    }
  end
  def handle_info({:calendar_exited, _reason,  %{name: calendar_id}}, socket) when calendar_id == socket.assigns.calendar.id do
    {
      :noreply,
      socket
      |> assign(:calendar_state, nil)
    }
  end
  def handle_info({:calendar_exited, _, _}, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Calendar"
  defp page_title(:edit), do: "Edit Calendar"
  defp page_title(:add_event), do: "Add event to Calendar"


  def ensure_assign(socket, key, default_value) do
    assign(
      socket,
      key,
      Map.get(socket.assigns, key, default_value)
    )
  end
end
