timer_event = fn name, delay, next_events ->
  %{
    name: name,
    start: :event,
    desc: %{type: :delay, delay: delay},
    on_finish: %{next_events: next_events}
  }
end

manual_event = fn name, next_events ->
  %{
    name: name,
    start: :event,
    desc: %{type: :manual},
    on_finish: %{next_events: next_events}
  }
end

Schudelu.Calendar.create("toto")
[first_event] = (
  1..10
  |> Enum.reduce([], fn idx, acc ->
    name_id = 11 - idx
    {:ok, id} = Schudelu.Calendar.schedule("toto", timer_event.("Timer 3s-#{name_id}", :timer.seconds(3), acc))
    [id]
  end)
)

{:ok, id} = Schudelu.Calendar.schedule("toto", manual_event.("Manual-#{0}", [first_event]))

Schudelu.Calendar.entry_point("toto", id)
Schudelu.Calendar.Sup.debug("toto")
Schudelu.Calendar.start_events("toto", [id])
Schudelu.Calendar.Sup.debug("toto")
