defmodule Schudelu.ToolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Schudelu.Tools` context.
  """

  @doc """
  Generate a calendar.
  """
  def calendar_fixture(attrs \\ %{}) do
    {:ok, calendar} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Schudelu.Tools.create_calendar()

    calendar
  end

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Schudelu.Tools.create_event()

    event
  end
end
