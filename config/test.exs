use Mix.Config

# Configure your database
config :timesheet_app, TimesheetApp.Repo,
  username: "timesheet_app",
  password: "timesheet_app",
  database: "timesheet_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :timesheet_app, TimesheetAppWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
