defmodule TaskmasterWeb.SessionController do
  use TaskmasterWeb, :controller

  def create(conn, %{"username" => username}) do
    user = Taskmaster.Users.get_user_by_username(username)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as \"#{user.username}\".")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Failed to login.")
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
