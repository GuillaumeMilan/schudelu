defmodule SchudeluWeb.EventLive.Index do
  use SchudeluWeb, :live_view

  alias Schudelu.Tools
  alias Schudelu.Tools.Event

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :event_collection, list_event())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Tools.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{calendar_id: socket.assign.calendar.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Event")
    |> assign(:event, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Tools.get_event!(id)
    {:ok, _} = Tools.delete_event(event)

    {:noreply, assign(socket, :event_collection, list_event())}
  end

  defp list_event do
    Tools.list_event()
  end
end
