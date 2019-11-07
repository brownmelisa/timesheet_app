defmodule TimesheetApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :is_manager, :boolean, default: false, null: false
      add :password, :string
      add :password_hash, :string
      add :password_confirmation, :string
      add :manager_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:manager_id])
  end
end
