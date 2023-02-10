defmodule Schudelu.PubSub do
  alias Phoenix.PubSub
  alias Schudelu.Repo

  def calendars_topic(owner) do
    "calendars:#{owner}"
  end
  def calendar_topic(calendar_id) do
    "calendar:#{calendar_id}"
  end

  def broadcast({:calendar, event}, calendar) do
    owners = [:public]
    topics = [
      calendar_topic(calendar.id)|
      Enum.map(owners, &calendars_topic/1),
    ]
    message = {:calendar, event, calendar}
    do_broadcast(topics, message)
  end

  def broadcast({:event, event_name}, event) do
    topics = [
      calendar_topic(event.calendar_id)
    ]
    message = {:event, event_name, event}
    do_broadcast(topics, message)
  end

  def broadcast({:event_vertex, event, event_vertex}) do
    ref_event = (
      cond do
        Ecto.assoc_loaded?(event_vertex.from_event) -> event_vertex.from_event
        Ecto.assoc_loaded?(event_vertex.to_event) -> event_vertex.to_event
        true -> Repo.preload(event_vertex, [:from_event]).from_event
      end
    )
    topics = [
      calendar_topic(ref_event.calendar_id)
    ]

    message = {:event_vertex, event, event_vertex}
    do_broadcast(topics, message)
  end

  def do_broadcast(topics, message) when is_list(topics), do: Enum.map(topics, &do_broadcast(&1, message))
  def do_broadcast(topic, message) when is_binary(topic), do: PubSub.broadcast(__MODULE__, topic, message)

  def subscribe(topic), do: PubSub.subscribe(__MODULE__, topic)

  def unsubscribe(topic), do: PubSub.unsubscribe(__MODULE__, topic)
end
