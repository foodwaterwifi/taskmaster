defmodule Taskmaster.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, default: "Title", null: false
      add :desc, :string, default: "Description", null: false
      add :completed, :boolean, default: false, null: false
      add :time_spent, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:user_id])
  end
end
