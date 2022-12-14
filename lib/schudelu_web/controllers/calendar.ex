defmodule SchudeluWeb.Controllers.Calendar do
  use Phoenix.LiveView
  #import Phoenix.HTML.Form


  def mount(%{"calendar_id" => calendar_id} = _params, session, socket) do
    require Logger
    Logger.debug("#{inspect __MODULE__} Session #{inspect session}")
    case Schudelu.Calendar.create(calendar_id) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
    Schudelu.Calendar.subscribe(calendar_id, session["_csrf_token"])
    {
      :ok,
      socket
      |> assign(:calendar_id, calendar_id)
      |> assign(:calendar_state, nil)
      |> assign(:debug_mode, false)
    }
  end

  def handle_event("click-debug-toggle", _params, socket) do
    {
      :noreply,
      socket
      |> assign(:debug_mode, !socket.assigns.debug_mode)
    }
  end
  def handle_event("event-finished-"<>id, _params, socket) do
    Schudelu.Calendar.finish_event(socket.assigns.calendar_id, String.to_integer(id))
    {
      :noreply,
      socket
    }
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
    Logger.debug("Socket received message from calendar #{inspect calendar_name} with new calendar state: \n#{inspect new_state, pretty: true}")
    {
      :noreply,
      socket
      |> assign(:calendar_state, new_state)
    }
  end

  defdelegate render(assigns), to: SchudeluWeb.Views.CalendarExecution
end
