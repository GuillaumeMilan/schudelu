defmodule Schudelu.Tools.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendar" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
