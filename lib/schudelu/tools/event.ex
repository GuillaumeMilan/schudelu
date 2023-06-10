defmodule Schudelu.Tools.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Schudelu.Tools.Event.Args

  schema "event" do
    field :name, :string
    field :type, Ecto.Enum, values: [:delay, :manual], default: :delay
    embeds_one :args, Args, on_replace: :delete
    field :is_entry_point, :boolean
    belongs_to(:calendar, Schudelu.Tools.Calendar)
    has_many(:from_event_vertex, Schudelu.Tools.EventVertex, foreign_key: :from_event_id, on_delete: :delete_all)
    has_many(:to_event_vertex, Schudelu.Tools.EventVertex, foreign_key: :to_event_id, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :type, :calendar_id, :is_entry_point])
    |> cast_embed(:args)
    |> validate_required([:name])
    |> validate_required([:calendar_id])
  end
end
