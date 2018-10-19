defmodule Taskmaster.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :desc, :string
    field :time_spent, :integer
    field :title, :string
    belongs_to :user, Taskmaster.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :time_spent, :user_id])
    |> validate_required([:title, :desc, :completed, :time_spent, :user_id])
  end
end
