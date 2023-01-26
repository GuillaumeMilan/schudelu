defmodule SchudeluWeb.EventVertexLive.FormComponent do
  use SchudeluWeb, :live_component

  alias Schudelu.Tools

  @impl true
  def update(%{event_vertex: event_vertex} = assigns, socket) do
    changeset = Tools.change_event_vertex(event_vertex)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"event_vertex" => event_vertex_params}, socket) do
    changeset =
      socket.assigns.event_vertex
      |> Tools.change_event_vertex(event_vertex_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"event_vertex" => event_vertex_params}, socket) do
    save_event_vertex(socket, socket.assigns.action, event_vertex_params)
  end

  defp save_event_vertex(socket, :link_events, event_vertex_params) do
    case Tools.create_event_vertex(event_vertex_params) do
      {:ok, _event_vertex} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event vertex created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
