defmodule TimesheetAppWeb.UserController do
  use TimesheetAppWeb, :controller
  
  alias TimesheetApp.Users
  alias TimesheetApp.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :index))
        #|> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    #user = Users.get_user!(id)
    user = Users.get_user_with_timesheets!(id)
    render(conn, "show.html", user: user)
  end

  # get jobs that a manager is in charge of
  def show_manager_jobs(conn, %{"id" => id}) do
    user = Users.get_user_with_jobs!(id)
    render(conn, "show_manager_jobs.html", user: user)
  end

  # get a summary of timesheets for the workers that manager supervises
  def show_manager_timesheets(conn, %{"id" => id}) do
    user = Users.get_manager_with_workers!(id)
    render(conn, "show_manager_timesheets.html", user: user)
  end

  # get a summary of timesheets for a specific worker that manager supervises
  # this is different from the user's show page because timesheets will be 
  # editable.
  def show_worker_timesheets(conn, %{"id" => id}) do
    user = Users.get_user_with_timesheets!(id)
    render(conn, "show_worker_timesheets.html", user: user)
  end  

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
