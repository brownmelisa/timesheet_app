defmodule TimesheetApp.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :budget_hours, :integer
    field :description, :string
    field :job_code, :string
    field :name, :string
    #field :user_id, :id

    belongs_to :user, TimesheetApp.Users.User    
    has_many :tasks, TimesheetApp.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:budget_hours, :description, :job_code, :name, :user_id])
    |> validate_required([:budget_hours, :description, :job_code, :name, :user_id])
  end
end
