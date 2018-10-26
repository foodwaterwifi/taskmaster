defmodule TaskmasterWeb.TaskView do
  use TaskmasterWeb, :view

  def get_assignee_name(changeset) do
    assignee_name = Ecto.Changeset.get_change(changeset, :new_assignee_name)
    assignee = Ecto.Changeset.get_field(changeset, :assignee)
    cond do
      assignee_name -> assignee_name
      assignee -> assignee.username
      true -> ""
    end
  end

  def calculate_time_spent(task) do
    time_blocks = task.time_blocks
    time_spent_seconds = Enum.sum(Enum.map(time_blocks, fn tb -> tb.end_time - tb.start_time end))
    seconds = rem(time_spent_seconds, 60)
    minutes = rem(div(time_spent_seconds, 60), 60)
    hours = div(time_spent_seconds, 3600)
    "#{Integer.to_string(hours)} h #{Integer.to_string(minutes)} m #{Integer.to_string(seconds)} s"
  end
end
