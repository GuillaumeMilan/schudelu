defmodule SchudeluWeb.CalendarLive.Edit do
  use SchudeluWeb, :live_view

  alias Schudelu.Tools
  alias Schudelu.Tools.Calendar
  alias Schudelu.Tools.Event
  alias Schudelu.Tools.EventVertex

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do

    events = list_events(id)
    event_vertices = list_event_vertices(events)
    {
      :noreply,
      socket
      |> assign(:calendar, Tools.get_calendar!(id))
      |> assign(:events, events)
      |> assign(:event_vertices, event_vertices)
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Edit Calendar")
  end

  defp apply_action(socket, :add_event, _params) do
    socket
    |> assign(:page_title, "Calendar Link Events")
    |> assign(:event, %Event{calendar_id: socket.assigns.calendar.id})
  end

  defp apply_action(socket, :edit_event, %{"event_id" => event_id}) do
    socket
    |> assign(:page_title, "Calendar Edit Event")
    |> assign(:event, Tools.get_event!(event_id))
  end

  defp apply_action(socket, :link_events, _params) do
    socket
    |> assign(:page_title, "Calendar Link Events")
    |> assign(:event_vertex, %EventVertex{})
  end

  @impl true
  def handle_event("delete_event", %{"id" => id}, socket) do
    Tools.get_event!(id)
    |> Tools.delete_event()

    events = list_events(socket.assigns.calendar.id)
    {
      :noreply,
      socket
      |> assign(:events, events)
      |> assign(:event_vertices, list_event_vertices(events))
    }
  end
  def handle_event("delete_event_vertex", %{"id" => id}, socket) do
    Tools.get_event_vertex!(id)
    |> Tools.delete_event_vertex()

    {
      :noreply,
      socket
      |> assign(:event_vertices, list_event_vertices(socket.assigns.events))
    }
  end

  def list_events(calendar_id) do
    Tools.list_event_in_calendar(calendar_id) |> Map.new(fn event -> {event.id, event} end)
  end

  def list_event_vertices(events) do
    events |> Map.keys() |> Enum.flat_map(&Tools.list_event_vertex_referencing/1) |> Enum.uniq()
  end
end
