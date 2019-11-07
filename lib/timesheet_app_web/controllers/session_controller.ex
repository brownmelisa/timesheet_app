defmodule TimesheetAppWeb.SessionController do
  use TimesheetAppWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    user = TimesheetApp.Users.authenticate(email, password)
    # redirect according to whether user is manager or worker
    #if user.manager do
    if user do
      IO.puts("In session controller: user is successfully authenticated")
      IO.inspect(user)
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.email}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      IO.puts("In session controller: login failed")
      IO.inspect(user)
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

