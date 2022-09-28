defmodule SchudeluWeb.Views.CalendarExecution do
  use Phoenix.LiveView

  @max_timeline_depth 10

  def construct_tree(event, _, 0) do
    put_in(event, [:event, :on_finish], %{next_events: []})
  end
  def construct_tree(%{event: %{on_finish: %{next_events: next_events}}} = event, event_map, rem_depth) do
    put_in(event, [:event, :on_finish, :next_events], next_events |> Enum.map(&construct_tree(Map.get(event_map, &1), event_map, rem_depth - 1)))
  end
  def construct_tree(event, _, _) do
    event
  end

  def timeline(%{events: events}, debug_mode) do
    runnings = events |> Enum.map(fn {_, event} -> event end) |> Enum.filter(fn event -> match?({:started, _}, event.state) end)

    timelines = runnings
                |> Enum.map(fn event ->
                  construct_tree(event, events, @max_timeline_depth)
                end)

    draw = draw_timelines(timelines, "") |> List.wrap() |> List.flatten |> Enum.join("\n")
    #draw = ""
    assigns = %{timelines: timelines, draw: draw}
    case debug_mode do
      false ->
        ~L"""
        <pre><code><%= @draw %></code></pre>
        """
      true ->
        ~L"""
        <pre><code><%= inspect(@timelines, pretty: true)%></code></pre>
        """
    end
  end
  def timeline(_, _) do
    assigns = nil
    ~L"""
    """
  end
  def draw_timelines([], current_draw) do
    current_draw
  end
  def draw_timelines([first_timeline| others], current_draw) do
    [
      draw_timelines(first_timeline.event.on_finish.next_events, current_draw <> " > " <> first_timeline.event.name)|
      Enum.map(others, fn timeline ->
        blank_line = String.pad_leading("", current_draw |> String.length(), " ")
        draw_timelines(timeline.event.on_finish.next_events, blank_line <> " > " <> timeline.event.name)
      end)
    ]
  end

  def render_actions(%{events: events},debug_mode) do
    events = events |> Enum.flat_map(fn {id, desc} -> to_actions(id, desc) end)
    assigns = %{debug_mode: debug_mode, events: events}
    ~L"""
    <table>
    <thead>
    <tr><th colspan="2">Actions</th></tr>
    </thead>
    <tbody>
      <tr>
        <th>Debug mode</th>
        <th>
          <div
            class="<%= if @debug_mode do %>phx-toggle on<%else%>phx-toggle off<%end%>"
            phx-click="click-debug-toggle"
          ><div class="phx-toggle-dot"></div></div>
        </th>
      </tr>
      <%= for %{desc: desc, action: action} <- events do %>
        <tr>
          <th>
            <%= desc %>
          </th>
          <th>
            <%= action %>
          </th>
        </tr>
      <%end%>
    </tbody>
    </table>
    """
  end
  def render_actions(_,_) do
    assigns = nil
    ~L"""
    """
  end

  def to_actions(id, %{event: %{desc: %{type: :manual}, name: name}, state: {:started, nil}}) do
    assigns = %{event: "event-finished-#{id}"}
    terminate_render = ~L"""
    <button phx-click="<%= assigns.event %>"><%= name%> done!</button>
    """
    [%{desc: "#{name} done!", id: id, action: terminate_render}]
  end
  def to_actions(_id, %{event: %{desc: %{type: :delay}}}) do
    []
  end
  def to_actions(_id, _) do
    []
  end

  def render(assigns) do
    ~L"""
    <h1> Calendar: <%= @calendar_id %> </h1>
    <h2>Actions</h2>
    <%= render_actions(@calendar_state, @debug_mode) %>
    <h2> Calendar state</h2>
    <%= if @debug_mode do %>
      <h3> Debug mode enabled </h3>
      <pre><code><%= inspect(@calendar_state, pretty: true)%></code></pre
    <% end %>
    <h2> Timeline state<h2>
    <%= timeline(@calendar_state, @debug_mode) %>
    """
  end
end
