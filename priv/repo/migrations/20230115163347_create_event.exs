defmodule Schudelu.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:event) do
      add :name, :string

      timestamps()
    end
  end
end
