defmodule TimesheetApp.Timesheets do
  @moduledoc """
  The Timesheets context.
  """

  import Ecto.Query, warn: false
  alias TimesheetApp.Repo

  alias TimesheetApp.Timesheets.Timesheet

  @doc """
  Returns the list of timesheets.

  ## Examples

      iex> list_timesheets()
      [%Timesheet{}, ...]

  """
  def list_timesheets do
    Repo.all(Timesheet)
  end

  @doc """
  Gets a single timesheet.

  Raises `Ecto.NoResultsError` if the Timesheet does not exist.

  ## Examples

      iex> get_timesheet!(123)
      %Timesheet{}

      iex> get_timesheet!(456)
      ** (Ecto.NoResultsError)

  """
  #def get_timesheet!(id), do: Repo.get!(Timesheet, id)
  def get_timesheet!(id) do
    Repo.one! from t in Timesheet,
      where: t.id == ^id,
      preload: [:user]
  end

  @doc """
  Creates a timesheet.

  ## Examples

      iex> create_timesheet(%{field: value})
      {:ok, %Timesheet{}}

      iex> create_timesheet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timesheet(attrs \\ %{}) do
    IO.puts("creating timesheet inside timesheets.ex...")
    IO.inspect(attrs)
    %Timesheet{}
    |> Timesheet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timesheet.

  ## Examples

      iex> update_timesheet(timesheet, %{field: new_value})
      {:ok, %Timesheet{}}

      iex> update_timesheet(timesheet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timesheet(%Timesheet{} = timesheet, attrs) do
    timesheet
    |> Timesheet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timesheet.

  ## Examples

      iex> delete_timesheet(timesheet)
      {:ok, %Timesheet{}}

      iex> delete_timesheet(timesheet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timesheet(%Timesheet{} = timesheet) do
    Repo.delete(timesheet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timesheet changes.

  ## Examples

      iex> change_timesheet(timesheet)
      %Ecto.Changeset{source: %Timesheet{}}

  """
  def change_timesheet(%Timesheet{} = timesheet) do
    Timesheet.changeset(timesheet, %{})
  end

  def get_timesheet_with_tasks!(id) do
    Repo.one from tt in Timesheet,
      where: tt.id == ^id,
      preload: [:tasks]
  end

  def get_last_timesheet_id() do
    last = Repo.one from tt in Timesheet,
                    order_by: [desc: tt.id],
                    limit: 1
    last.id
  end

end
