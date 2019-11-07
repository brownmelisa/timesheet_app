defmodule TimesheetApp.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias TimesheetApp.Repo

  alias TimesheetApp.Jobs.Job
  #alias TimesheetApp.Users.User
  alias TimesheetApp.Tasks.Task

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  #def get_job!(id), do: Repo.get!(Job, id)
  def get_job!(id) do
    Repo.one! from j in Job,
      where: j.id == ^id,
      preload: [:user]
  end

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{source: %Job{}}

  """
  def change_job(%Job{} = job) do
    Job.changeset(job, %{})
  end

  # get the hours spent on a job by summing the tasks
  def get_hours_spent(id) do
    result =
      Repo.all(from t in Task, where: t.job_id == ^id)
      |> Enum.reduce(0, fn x, acc -> x.hours_worked + acc end)
    result
  end

  #calculate if job is over budget
  def get_hours_left(id) do
    get_job!(id).budget_hours - get_hours_spent(id)
  end

  # get job with tasks preloaded
  def get_job_with_tasks!(id) do
    Repo.one from jj in Job,
      where: jj.id == ^id,
      preload: [:tasks]
  end

  def list_job_codes do 
    Repo.all(Job)
    |> Enum.map(fn x -> x.job_code end)
  end

  # get the job id given a code
  def get_job_id_from_code!(code) do
    job = Repo.one from jj in Job,
             where: jj.job_code == ^code
    job.id
  end
end
