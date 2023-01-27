defmodule Schudelu.Repo.Migrations.AddEventEntryPointState do
  use Ecto.Migration

  def change do
    alter table(:event) do
      add(:is_entry_point, :boolean, default: false)
    end
  end
end
