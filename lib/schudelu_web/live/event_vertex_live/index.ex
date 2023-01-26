defmodule SchudeluWeb.EventVertexLive.Index do
  use SchudeluWeb, :live_view

  alias Schudelu.Tools
  alias Schudelu.Tools.EventVertex

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :event_vertex_collection, list_event_vertex())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event vertex")
    |> assign(:event_vertex, Tools.get_event_vertex!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event vertex")
    |> assign(:event_vertex, %EventVertex{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Event vertex")
    |> assign(:event_vertex, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event_vertex = Tools.get_event_vertex!(id)
    {:ok, _} = Tools.delete_event_vertex(event_vertex)

    {:noreply, assign(socket, :event_vertex_collection, list_event_vertex())}
  end

  defp list_event_vertex do
    Tools.list_event_vertex()
  end
end
