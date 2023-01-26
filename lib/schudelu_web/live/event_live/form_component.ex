defmodule SchudeluWeb.EventLive.FormComponent do
  use SchudeluWeb, :live_component

  alias Schudelu.Tools

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Tools.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Tools.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    require Logger
    Logger.debug("PArams #{inspect event_params}")
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit_event, event_params) do
    case Tools.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :add_event, event_params) do
    case Tools.create_event(event_params |> Map.put("calendar_id", socket.assigns.event.calendar_id)) do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
