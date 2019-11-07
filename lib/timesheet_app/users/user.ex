defmodule TimesheetApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_manager, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    #field :manager_id, :id

    has_many :timesheets, TimesheetApp.Timesheets.Timesheet
    has_many :jobs, TimesheetApp.Jobs.Job
    
    # implement the manager/worker relationship
    belongs_to :manager, TimesheetApp.Users.User
    has_many :workers, TimesheetApp.Users.User, foreign_key: :manager_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, 
      [:name, :email, :is_manager, :password,:password_confirmation, :manager_id])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 8) # too short
    |> hash_password()
    |> validate_required([:name, :email, :is_manager, :password_hash])
    |> unique_constraint(:email)
  end

  def hash_password(cset) do
    pw = get_change(cset, :password)
    if pw do
      change(cset, Argon2.add_hash(pw))
    else
      cset
    end
  end
end
