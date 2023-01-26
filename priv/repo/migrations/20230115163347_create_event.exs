defmodule Schudelu.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:event) do
      add :name, :string
      add :type, :string
      add :args, :map
      add :calendar_id, references(:calendar)

      timestamps()
    end
  end
end
