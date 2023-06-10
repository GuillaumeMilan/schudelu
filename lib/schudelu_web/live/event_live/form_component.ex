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

  def event_args(%{source: changeset} = html_form) do
    _event_args(Ecto.Changeset.get_field(changeset, :type), html_form)
  end

  def _event_args(:delay, f) do
    #(Schudelu.Tools.Event.DelayArgs.changeset(%Schudelu.Tools.Event.DelayArgs{}, args) |> Schudelu.Tools.Event.DelayArgs.changeset(%{delay: 3})).params
    # TODO Create the changeset from this and then ...
    assigns = %{}
    ~H"""
    <%= label f, :args, "Count down" %>
    <%= for fa <- inputs_for(f, :args) do %>
      <%= text_input fa, :delay_value, autocomplete: false, type: _delay_args_input_type(fa)%>
      <%= select fa, :delay_unit, ["Seconds": :second, "Minutes": :minute] %>
    <% end %>
    <%= error_tag f, :args%>
    """
  end
  def _event_args(:manual, _) do
    assigns = %{}
    ~H"""
    """
  end


  def _delay_args_input_type(form) do
    require Logger
    Logger.debug("_delay_args_form #{inspect form}")
    Logger.debug("_delay_args_form_value #{inspect Phoenix.HTML.Form.input_value(form, :delay_unit)}")
    case "#{Phoenix.HTML.Form.input_value(form, :delay_unit)}" do
      "second" -> "number"
      "minute" -> "number"
    end
  end

end
