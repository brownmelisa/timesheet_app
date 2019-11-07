defmodule TimesheetApp.Repo do
  use Ecto.Repo,
    otp_app: :timesheet_app,
    adapter: Ecto.Adapters.Postgres
end
