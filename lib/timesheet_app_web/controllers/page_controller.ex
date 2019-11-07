defmodule TimesheetAppWeb.PageController do
  use TimesheetAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
