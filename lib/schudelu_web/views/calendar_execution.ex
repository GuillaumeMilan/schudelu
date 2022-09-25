defmodule SchudeluWeb.Views.CalendarExecution do
  use Phoenix.LiveView

  @max_timeline_depth 10

  def construct_tree(event, _, 0) do
    put_in(event, [:event, :on_finish], %{next_events: []})
  end
  def construct_tree(%{event: %{on_finish: %{next_events: next_events}}} = event, event_map, rem_depth) do
    require Logger
    Logger.debug("Trying to construct tree #{inspect [event, event_map, rem_depth], pretty: true}")
    put_in(event, [:event, :on_finish, :next_events], next_events |> Enum.map(&construct_tree(Map.get(event_map, &1), event_map, rem_depth - 1)))
  end
  def construct_tree(event, _, _) do
    event
  end

  def timeline(%{events: events}) do
    require Logger
    runnings = events |> Enum.map(fn {_, event} -> event end) |> Enum.filter(fn event -> match?({:started, _}, event.state) end)
    Logger.debug("Runnings: #{inspect runnings, pretty: true}")

    timelines = runnings
                |> Enum.map(fn event ->
                  construct_tree(event, events, @max_timeline_depth)
                end)

    draw = draw_timelines(timelines, "") |> List.wrap() |> List.flatten |> Enum.join("\n")
    #draw = ""
    assigns = %{timelines: timelines, draw: draw}
    ~L"""
    <pre><code><%= @draw %></code></pre>
    <pre><code><%= inspect(@timelines, pretty: true)%></code></pre>
    """
  end
  def timeline(_) do
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

  def actions(%{events: _events}) do
    assigns = nil
    ~L"""
    TODO
    """
  end
  def actions(_) do
    assigns = nil
    ~L"""
    """
  end

  def render(assigns) do
    ~L"""
    <h1> Calendar: <%= @calendar_id %> </h1>
    <h2>Actions</h2>
    <%= actions(@calendar_state) %>
    <h2> Calendar state</h2>
    <pre><code><%= inspect(@calendar_state, pretty: true)%></code></pre>
    <h2> Timeline state<h2>
    <%= timeline(@calendar_state) %>
    """
  end
end
