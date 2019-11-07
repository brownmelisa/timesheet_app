defmodule TimesheetAppWeb.JobController do
  use TimesheetAppWeb, :controller

  alias TimesheetApp.Jobs
  alias TimesheetApp.Jobs.Job

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, "index.html", jobs: jobs)
  end

  def new(conn, _params) do
    changeset = Jobs.change_job(%Job{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"job" => job_params}) do
    job_params = Map.put(job_params, "user_id", TimesheetApp.Users.get_user_id_from_name(job_params["manager_name"]))
    case Jobs.create_job(job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: Routes.job_path(conn, :show, job))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    #job = Jobs.get_job!(id)
    job = Jobs.get_job_with_tasks!(id)
    render(conn, "show.html", job: job)
  end

  def edit(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    changeset = Jobs.change_job(job)
    render(conn, "edit.html", job: job, changeset: changeset)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Jobs.get_job!(id)

    case Jobs.update_job(job, job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job updated successfully.")
        |> redirect(to: Routes.job_path(conn, :show, job))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", job: job, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    {:ok, _job} = Jobs.delete_job(job)

    conn
    |> put_flash(:info, "Job deleted successfully.")
    |> redirect(to: Routes.job_path(conn, :index))
  end
end
