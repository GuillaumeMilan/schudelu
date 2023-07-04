defmodule SchudeluWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.calendar_index_path(@socket, :index)}>
        <.live_component
          module={SchudeluWeb.CalendarLive.FormComponent}
          id={@calendar.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.calendar_index_path(@socket, :index)}
          calendar: @calendar
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def main_cta(assigns) do
    ~H"""
    <div class="bg-gray p-4 rounded-2xl shadow-solid-3xl shadow-gray-dark">
      <div class="flex justify-between items-center">
        <div class="bg-black h-12 w-12 rounded-full p-1 mr-4">
          <SchudeluWeb.SvgIconsView.icon name={@icon_name} />
        </div>
        <div>
          <div class="text-gray-light text-xs"><%= @subtitle %></div>
          <div class="text-xl"><%= @title %></div>
        </div>
        <div class="bg-gray-blue h-8 w-8 rounded-lg p-1">
          <SchudeluWeb.SvgIconsView.icon name="chevrons-right" />
        </div>
      </div>
    </div>
    """
  end

  def thumb(assigns) do
    require Logger
    ~H"""
    <div class="bg-gray p-4 rounded-2xl">
      <div class="mb-4">
        <div class="text-2xl"><%= render_slot(@title) %></div>
        <div class="text-2xl text-gray-light">Workout</div>
      </div>
      <div class="flex justify-between">
        <button><%= render_slot(@cta) %></button>
        <div class="italic text-gray-light"> Stats incomming...</div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
