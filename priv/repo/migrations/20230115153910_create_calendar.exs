defmodule Schudelu.Repo.Migrations.CreateCalendar do
  use Ecto.Migration

  def change do
    create table(:calendar) do
      add :name, :string

      timestamps()
    end
  end
end
