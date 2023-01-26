defmodule Schudelu.Repo.Migrations.CreateEventVertex do
  use Ecto.Migration

  def change do
    create table(:event_vertex) do

      add :from_event_id, references(:event)
      add :to_event_id, references(:event)

      timestamps()
    end
  end
end
