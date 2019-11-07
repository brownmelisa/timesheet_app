defmodule TimesheetApp.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :budget_hours, :integer, null: false
      add :description, :text, null: false
      add :job_code, :string, null: false
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:jobs, [:user_id])
  end
end
