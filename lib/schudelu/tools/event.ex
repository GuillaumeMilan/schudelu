defmodule Schudelu.Tools.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event" do
    field :name, :string
    field :type, Ecto.Enum, values: [:delay, :manual]
    field :args, :map
    belongs_to(:calendar, Schudelu.Tools.Calendar)
    has_many(:from_event_vertex, Schudelu.Tools.EventVertex, foreign_key: :from_event_id, on_delete: :delete_all)
    has_many(:to_event_vertex, Schudelu.Tools.EventVertex, foreign_key: :to_event_id, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :type, :args, :calendar_id])
    |> validate_required([:name])
    |> validate_required([:calendar_id])
  end
end
