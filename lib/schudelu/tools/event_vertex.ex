defmodule Schudelu.Tools.EventVertex do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_vertex" do
    belongs_to(:from_event, Schudelu.Tools.Event)
    belongs_to(:to_event, Schudelu.Tools.Event)


    timestamps()
  end

  @doc false
  def changeset(event_vertex, attrs) do
    event_vertex
    |> cast(attrs, [:from_event_id, :to_event_id])
    |> validate_required([])
  end
end
