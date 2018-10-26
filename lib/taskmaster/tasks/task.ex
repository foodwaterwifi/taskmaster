defmodule Taskmaster.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean
    field :desc, :string
    field :title, :string
    belongs_to :assignee, Taskmaster.Users.User
    has_many :time_blocks, Taskmaster.TimeBlocks.TimeBlock

    field :new_assignee_name, :string, virtual: true # name of user to be assigned the task
    field :assigned_by, :integer, virtual: true # user id of person who assigned this task to the user

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :new_assignee_name, :assigned_by])
    |> process_assignee_name()
    |> validate_required([:title, :desc, :completed])
  end

  def process_assignee_name(changeset) do
    new_name = get_change(changeset, :new_assignee_name)
    assigned_by = get_field(changeset, :assigned_by)
    IO.puts "Task assigned to"
    IO.inspect new_name
    IO.puts "by"
    IO.inspect assigned_by
    if new_name do
      assignee = Taskmaster.Users.get_user_by_username(new_name)
      changed_by_manager = assignee && assignee.manager_id && (assignee.manager_id == assigned_by)
      cond do
        assignee == nil ->
          add_error(changeset, :new_assignee_name, "user does not exist.")
        changed_by_manager ->
          put_change(changeset, :assignee_id, assignee.id)
        true ->
          add_error(changeset, :new_assignee_name, "to assign a task to this user, you must be their manager.")
      end
    else
      changeset
    end
  end
end
