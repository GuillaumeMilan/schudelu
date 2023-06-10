defmodule Schudelu.Tools.Event.Args do
  use Ecto.Schema
  import Ecto.Changeset

  @derive [Jason.Encoder]
  @primary_key false
  embedded_schema do
    field(:delay_value, :integer, primary_key: true)
    field(:delay_unit, Ecto.Enum, values: [:second, :minute], default: :second)
  end

  def changeset(args, attrs) do
    args
    |> cast(attrs, [
      :delay_value,
      :delay_unit
    ])
  end
end
