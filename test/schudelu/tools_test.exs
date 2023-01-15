defmodule Schudelu.ToolsTest do
  use Schudelu.DataCase

  alias Schudelu.Tools

  describe "calendar" do
    alias Schudelu.Tools.Calendar

    import Schudelu.ToolsFixtures

    @invalid_attrs %{name: nil}

    test "list_calendar/0 returns all calendar" do
      calendar = calendar_fixture()
      assert Tools.list_calendar() == [calendar]
    end

    test "get_calendar!/1 returns the calendar with given id" do
      calendar = calendar_fixture()
      assert Tools.get_calendar!(calendar.id) == calendar
    end

    test "create_calendar/1 with valid data creates a calendar" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Calendar{} = calendar} = Tools.create_calendar(valid_attrs)
      assert calendar.name == "some name"
    end

    test "create_calendar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tools.create_calendar(@invalid_attrs)
    end

    test "update_calendar/2 with valid data updates the calendar" do
      calendar = calendar_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Calendar{} = calendar} = Tools.update_calendar(calendar, update_attrs)
      assert calendar.name == "some updated name"
    end

    test "update_calendar/2 with invalid data returns error changeset" do
      calendar = calendar_fixture()
      assert {:error, %Ecto.Changeset{}} = Tools.update_calendar(calendar, @invalid_attrs)
      assert calendar == Tools.get_calendar!(calendar.id)
    end

    test "delete_calendar/1 deletes the calendar" do
      calendar = calendar_fixture()
      assert {:ok, %Calendar{}} = Tools.delete_calendar(calendar)
      assert_raise Ecto.NoResultsError, fn -> Tools.get_calendar!(calendar.id) end
    end

    test "change_calendar/1 returns a calendar changeset" do
      calendar = calendar_fixture()
      assert %Ecto.Changeset{} = Tools.change_calendar(calendar)
    end
  end

  describe "event" do
    alias Schudelu.Tools.Event

    import Schudelu.ToolsFixtures

    @invalid_attrs %{name: nil}

    test "list_event/0 returns all event" do
      event = event_fixture()
      assert Tools.list_event() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Tools.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Event{} = event} = Tools.create_event(valid_attrs)
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tools.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Event{} = event} = Tools.update_event(event, update_attrs)
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Tools.update_event(event, @invalid_attrs)
      assert event == Tools.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Tools.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Tools.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Tools.change_event(event)
    end
  end
end
