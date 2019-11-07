defmodule TimesheetAppWeb.Router do
  use TimesheetAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug TimesheetAppWeb.Plugs.FetchCurrentUser
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimesheetAppWeb do
    pipe_through :browser
    
    get "/", PageController, :index
    
    # added resources to display the individual database tables
    resources "/jobs", JobController
    resources "/users", UserController
    resources "/tasks", TaskController
    resources "/timesheets", TimesheetController
    resources "/sessions", SessionController,
              only: [:new, :create, :delete], singleton: true
  
    # added get resources
    get "/manager/:id/jobs", UserController, :show_manager_jobs
    get "/manager/:id/timesheets", UserController, :show_manager_timesheets
    get "/manager/:id/worker/:id/timesheets", UserController, :show_worker_timesheets

    # added post resources
    post("/timesheets/:id", TimesheetController, :approve)
  
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimesheetAppWeb do
  #   pipe_through :api
  # end
end
