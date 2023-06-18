defmodule SchudeluWeb.CalendarLive.Index do
  use SchudeluWeb, :live_view

  alias Schudelu.Tools
  alias Schudelu.Tools.Calendar
  alias Schudelu.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(PubSub.calendars_topic(:public))
    {:ok, assign(socket, :calendar_collection, list_calendar())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Calendar")
    |> assign(:calendar, %Calendar{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Calendar")
    |> assign(:calendar, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    calendar = Tools.get_calendar!(id)
    {:ok, _} = Tools.delete_calendar(calendar)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:calendar, _, _}, socket) do
    {:noreply, assign(socket, :calendar_collection, list_calendar())}
  end

  defp list_calendar do
    Tools.list_calendar()
  end
end
