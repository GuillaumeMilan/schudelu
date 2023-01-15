
fn calendar_id ->
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

  Schudelu.Calendar.create(calendar_id)
  [first_event] = (
    1..10
    |> Enum.reduce([], fn idx, acc ->
      name_id = 11 - idx
      {:ok, id} = Schudelu.Calendar.schedule(calendar_id, timer_event.("Timer 3s-#{name_id}", :timer.seconds(3), acc))
      [id]
    end)
  )

  {:ok, id} = Schudelu.Calendar.schedule(calendar_id, manual_event.("Manual-#{0}", [first_event]))

  Schudelu.Calendar.entry_point(calendar_id, id)
  Schudelu.Calendar.Sup.debug(calendar_id)
  Schudelu.Calendar.start_events(calendar_id, [id])
  Schudelu.Calendar.Sup.debug(calendar_id)
end
