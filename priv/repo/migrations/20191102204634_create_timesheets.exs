defmodule TimesheetApp.Repo.Migrations.CreateTimesheets do
  use Ecto.Migration

  def change do
    create table(:timesheets) do
      add :date, :date, null: false
      add :status, :string, null: false
      add :total_hours, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      
      timestamps()
    end

    create index(:timesheets, [:user_id])
  end
end
