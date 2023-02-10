defmodule Schudelu.Tools do
  @moduledoc """
  The Tools context.
  """

  import Ecto.Query, warn: false
  alias Schudelu.Repo
  alias Schudelu.PubSub

  alias Schudelu.Tools.Calendar

  @doc """
  Returns the list of calendar.

  ## Examples

      iex> list_calendar()
      [%Calendar{}, ...]

  """
  def list_calendar do
    Repo.all(Calendar)
  end

  @doc """
  Gets a single calendar.

  Raises `Ecto.NoResultsError` if the Calendar does not exist.

  ## Examples

      iex> get_calendar!(123)
      %Calendar{}

      iex> get_calendar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_calendar!(id), do: Repo.get!(Calendar, id)

  @doc """
  Creates a calendar.

  ## Examples

      iex> create_calendar(%{field: value})
      {:ok, %Calendar{}}

      iex> create_calendar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_calendar(attrs \\ %{}) do
    %Calendar{}
    |> Calendar.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, calendar} ->
        PubSub.broadcast({:calendar, :new}, calendar)
        {:ok, calendar}
      e -> e
    end
  end

  @doc """
  Updates a calendar.

  ## Examples

      iex> update_calendar(calendar, %{field: new_value})
      {:ok, %Calendar{}}

      iex> update_calendar(calendar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_calendar(%Calendar{} = calendar, attrs) do
    calendar
    |> Calendar.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, calendar} ->
        PubSub.broadcast({:calendar, :update}, calendar)
        {:ok, calendar}
      e -> e
    end
  end

  @doc """
  Deletes a calendar.

  ## Examples

      iex> delete_calendar(calendar)
      {:ok, %Calendar{}}

      iex> delete_calendar(calendar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_calendar(%Calendar{} = calendar) do
    Repo.delete(calendar)
    |> case do
      {:ok, calendar} ->
        PubSub.broadcast({:calendar, :delete}, calendar)
        {:ok, calendar}
      e -> e
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking calendar changes.

  ## Examples

      iex> change_calendar(calendar)
      %Ecto.Changeset{data: %Calendar{}}

  """
  def change_calendar(%Calendar{} = calendar, attrs \\ %{}) do
    Calendar.changeset(calendar, attrs)
  end

  alias Schudelu.Tools.Event

  @doc """
  Returns the list of event.

  ## Examples

      iex> list_event()
      [%Event{}, ...]

  """
  def list_event() do
    Repo.all(Event)
  end

  @doc """
  Returns the list of event in a calendar.

  ## Examples

      iex> list_event_in_calendar()
      [%Event{}, ...]

  """
  def list_event_in_calendar(calendar_id) do
    from(e in Event, where: e.calendar_id == ^calendar_id)
    |> Repo.all()
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, event} ->
        PubSub.broadcast({:event, :create}, event)
        {:ok, event}
      e -> e
    end
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, event} ->
        PubSub.broadcast({:event, :update}, event)
        {:ok, event}
      e -> e
    end
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
    |> case do
      {:ok, event} ->
        PubSub.broadcast({:event, :delete}, event)
        {:ok, event}
      e -> e
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias Schudelu.Tools.EventVertex

  @doc """
  Returns the list of event_vertex.

  ## Examples

      iex> list_event_vertex()
      [%EventVertex{}, ...]

  """
  def list_event_vertex do
    Repo.all(EventVertex)
  end

  def list_event_vertex_referencing(event_id) do
    from(ev in EventVertex, where: (ev.from_event_id == ^event_id) or (ev.to_event_id == ^event_id))
    |> Repo.all()
  end

  @doc """
  Gets a single event_vertex.

  Raises `Ecto.NoResultsError` if the Event vertex does not exist.

  ## Examples

      iex> get_event_vertex!(123)
      %EventVertex{}

      iex> get_event_vertex!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_vertex!(id), do: Repo.get!(EventVertex, id)

  @doc """
  Creates a event_vertex.

  ## Examples

      iex> create_event_vertex(%{field: value})
      {:ok, %EventVertex{}}

      iex> create_event_vertex(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_vertex(attrs \\ %{}) do
    %EventVertex{}
    |> EventVertex.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, event_vertex} ->
        PubSub.broadcast({:event_vertex, :create}, event_vertex)
        {:ok, event_vertex}
      e -> e
    end
  end

  @doc """
  Updates a event_vertex.

  ## Examples

      iex> update_event_vertex(event_vertex, %{field: new_value})
      {:ok, %EventVertex{}}

      iex> update_event_vertex(event_vertex, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_vertex(%EventVertex{} = event_vertex, attrs) do
    event_vertex
    |> EventVertex.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, event_vertex} ->
        PubSub.broadcast({:event_vertex, :update}, event_vertex)
        {:ok, event_vertex}
      e -> e
    end
  end

  @doc """
  Deletes a event_vertex.

  ## Examples

      iex> delete_event_vertex(event_vertex)
      {:ok, %EventVertex{}}

      iex> delete_event_vertex(event_vertex)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_vertex(%EventVertex{} = event_vertex) do
    Repo.delete(event_vertex)
    |> case do
      {:ok, event_vertex} ->
        PubSub.broadcast({:event_vertex, :delete}, event_vertex)
        {:ok, event_vertex}
      e -> e
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_vertex changes.

  ## Examples

      iex> change_event_vertex(event_vertex)
      %Ecto.Changeset{data: %EventVertex{}}

  """
  def change_event_vertex(%EventVertex{} = event_vertex, attrs \\ %{}) do
    EventVertex.changeset(event_vertex, attrs)
  end
end
