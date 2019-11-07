defmodule TimesheetApp.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :hours_worked, :integer, null: false
      add :note, :string, null: false
      add :job_id, references(:jobs, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :timesheet_id, references(:timesheets, on_delete: :delete_all), null: false
      
      timestamps()
    end

    create index(:task, [:job_id])
    create index(:task, [:user_id])
    create index(:task, [:timesheet_id])
  end
end
