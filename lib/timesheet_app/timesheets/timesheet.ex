defmodule TimesheetApp.Timesheets.Timesheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timesheets" do
    field :date, :date
    field :status, :string, default: "pending"
    field :total_hours, :integer
    #field :user_id, :id

    belongs_to :user, TimesheetApp.Users.User
    has_many :tasks, TimesheetApp.Tasks.Task

    timestamps()
  end

  @doc false
  # apply changes in attrs to this time sheet
  def changeset(timesheet, attrs) do
    timesheet
    # casting tells the changeset what params (i.e. keys in attrs map) to pass through,
    # all other keys will be ignored
    |> cast(attrs, [:date, :status, :total_hours, :user_id])
    # make sure association is preloaded in the changeset struct
    |> cast_assoc(:tasks, required: true)
    #|> cast_assoc(:tasks, with: &TimesheetApp.Task.changeset/2)
    |> validate_required([:date, :status, :total_hours, :user_id])
  end
end
