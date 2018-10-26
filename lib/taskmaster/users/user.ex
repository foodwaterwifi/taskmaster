defmodule Taskmaster.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :username, :string

    belongs_to :manager, Taskmaster.Users.User
    has_many :managees, Taskmaster.Users.User, foreign_key: :manager_id
    has_many :tasks, Taskmaster.Tasks.Task, foreign_key: :assignee_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :manager_id])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
