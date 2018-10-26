defmodule Taskmaster.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :manager_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:manager_id])
    create unique_index(:users, [:username])

  end
end
