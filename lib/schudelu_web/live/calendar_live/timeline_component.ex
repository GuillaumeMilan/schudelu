defmodule SchudeluWeb.CalendarLive.TimelineComponent do
  use SchudeluWeb, :live_component

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

  def timeline(%{calendar: calendar, calendar_state: calendar_state, debug_mode: debug_mode}) do
    require Logger
    Logger.debug("[TIMELINE] Received calendar props #{inspect calendar}")
    events = Map.get(calendar_state, :events, %{})
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

end
