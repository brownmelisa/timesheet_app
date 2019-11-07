defmodule TimesheetAppWeb.TimesheetController do
  use TimesheetAppWeb, :controller

  alias TimesheetApp.Timesheets
  alias TimesheetApp.Timesheets.Timesheet
  alias TimesheetApp.Users
  alias TimesheetApp.Jobs
  alias TimesheetApp.Repo

#  @behavior Ecto.Type
#  use Ecto.Type
#  import Ecto.Type

  def index(conn, _params) do
    timesheets = Timesheets.list_timesheets()
    render(conn, "index.html", timesheets: timesheets)
  end

  def new(conn, params) do
    #changeset = Timesheets.change_timesheet(%Timesheet{})
    changeset = Timesheet.changeset(
      %Timesheet{ tasks: 
        [ %TimesheetApp.Tasks.Task{}, 
          %TimesheetApp.Tasks.Task{},
          %TimesheetApp.Tasks.Task{},
          %TimesheetApp.Tasks.Task{},
          %TimesheetApp.Tasks.Task{},
          %TimesheetApp.Tasks.Task{},
          %TimesheetApp.Tasks.Task{},
          %TimesheetApp.Tasks.Task{}
        ]
      } , params)
    render(conn, "new.html", changeset: changeset)
  end

  ## HELPER FUNCTIONS FOR CREATE
  defp delete_empty_tasks(task_map) do
    task_map
    |> Enum.filter( fn{_key, value} -> value["hours_worked"] != "0" end)
    |> Enum.into( %{}, fn {k, v} -> {k, v} end)
  end

  defp insert_job_id(task_map) do
    task_map
    |> Enum.map(fn {key, value} ->
      %{key => Map.put(value, "job_id",
        Jobs.get_job_id_from_code!(value["job_code"]) )} end)
    |> reduce_task_list
  end

  defp insert_user_id(task_map, user_id) do
    task_map
    |> Enum.map(fn {key, value} ->
      %{key => Map.put(value, "user_id", user_id)} end)
    |> reduce_task_list
  end

  defp insert_timesheet_id(task_map) do
    task_map
    |> Enum.map(fn {key, value} ->
      %{key => Map.put(value, "timesheet_id",
        Timesheets.get_last_timesheet_id() + 1)} end)
    |> reduce_task_list
  end

  # reduce the task list into a map
  defp reduce_task_list(task_list) do
    task_list
    |> Enum.reduce(fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end) end)
  end
  ##############################

  def create(conn, %{"timesheet" => timesheet_params}) do
    IO.puts("printing out starting timesheet params...")
    IO.inspect(timesheet_params)

    # if user_name field exists, manager is entering in a worker's time sheet
    # otherwise use the current user's id for the timesheet id
    user_name = timesheet_params["user_name"]
    user_id =
      if user_name do
        Users.get_user_id_from_name(user_name)
      else
        conn.assigns[:current_user].id
      end
    timesheet_params = Map.put(timesheet_params, "user_id", user_id)

    # update the tasks map within the time sheet data structure
    updated_tasks = timesheet_params["tasks"]
      |> delete_empty_tasks
      |> insert_job_id
      |> insert_user_id(user_id)
      |> insert_timesheet_id
    timesheet_params = Map.put(timesheet_params, "tasks", updated_tasks)

    # calculate total hours for the time sheet by summing hours_worked for individual tasks
    total_hours = timesheet_params["tasks"]
      |> Enum.reduce(0, fn {_key, value}, acc ->
        String.to_integer(value["hours_worked"]) + acc end)
    timesheet_params = Map.put(timesheet_params, "total_hours", total_hours)
    IO.puts("printing out timesheet params after...")
    IO.inspect(timesheet_params)
    case Timesheets.create_timesheet(timesheet_params) do
      {:ok, timesheet} ->
        conn
        |> put_flash(:info, "Timesheet created successfully.")
        |> redirect(to: Routes.timesheet_path(conn, :show, timesheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    #timesheet = Timesheets.get_timesheet!(id)
    timesheet = Timesheets.get_timesheet_with_tasks!(id)
    render(conn, "show.html", timesheet: timesheet)
  end

  def edit(conn, %{"id" => id}) do
    #timesheet = Timesheets.get_timesheet!(id)
    timesheet = Repo.get!(Timesheet, id) |> Repo.preload(:tasks)
    changeset = Timesheets.change_timesheet(timesheet)
    #changeset = Timesheet.changeset(timesheet)
    render(conn, "edit.html", timesheet: timesheet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "timesheet" => timesheet_params}) do
    #timesheet = Timesheets.get_timesheet!(id)
    timesheet = Repo.get!(Timesheet, id) |> Repo.preload(:tasks)
    case Timesheets.update_timesheet(timesheet, timesheet_params) do
      {:ok, timesheet} ->
        conn
        |> put_flash(:info, "Timesheet updated successfully.")
        |> redirect(to: Routes.timesheet_path(conn, :show, timesheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", timesheet: timesheet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    timesheet = Timesheets.get_timesheet_with_tasks!(id)
    manager_id = TimesheetApp.Users.get_user!(timesheet.user_id).manager_id
    {:ok, _timesheet} = Timesheets.delete_timesheet(timesheet)
    conn
    |> put_flash(:info, "Timesheet deleted successfully.")
      #|> redirect(to: Routes.timesheet_path(conn, :index))
    |> redirect(to: "/manager/#{manager_id}/timesheets" )
  end
  
  # the id is the timesheet id
  def approve(conn, %{"id" => id}) do
    timesheet = Timesheets.get_timesheet_with_tasks!(id)
    manager_id = TimesheetApp.Users.get_user!(timesheet.user_id).manager_id
    case Timesheets.update_timesheet(timesheet,  %{status: "approved"}) do
      {:ok, _timesheet} ->
        conn
        |> put_flash(:info, "Timesheet approved successfully.")
        |> redirect(to: "/manager/#{manager_id}/timesheets" )
    end
  end

end
