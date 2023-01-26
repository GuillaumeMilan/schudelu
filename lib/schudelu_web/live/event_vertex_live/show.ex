defmodule SchudeluWeb.EventVertexLive.Show do
  use SchudeluWeb, :live_view

  alias Schudelu.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:event_vertex, Tools.get_event_vertex!(id))}
  end

  defp page_title(:show), do: "Show Event vertex"
  defp page_title(:edit), do: "Edit Event vertex"
end
