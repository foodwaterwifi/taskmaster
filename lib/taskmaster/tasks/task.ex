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
    changeset = task
    |> cast(attrs, [:title, :desc, :completed, :time_spent])
    |> validate_required([:title, :desc, :completed, :time_spent])

    # This is for the web form. Is there a better way I could do this?
    # I want to have a string to be loaded in the web form, and I want the string to be converted to an id locally.
    # Perhaps if I had a better way to structure my application I would have a better place to put this.
    if Ecto.assoc_loaded?(task.user) do
      put_change(changeset, :assignee, task.user.username)
    else
      put_change(changeset, :assignee, "")
    end
  end
end
