defmodule TimesheetApp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task" do
    field :hours_worked, :integer
    field :note, :string
    #field :job_id, :id
    field :user_id, :id
    #field :timesheet_id, :id

    belongs_to :timesheet, TimesheetApp.Timesheets.Timesheet
    belongs_to :job, TimesheetApp.Jobs.Job

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:hours_worked, :note, :timesheet_id, :job_id, :user_id])
    |> validate_required([:hours_worked, :note, :timesheet_id, :job_id, :user_id])
  end
end
