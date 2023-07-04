defmodule SchudeluWeb.PageController do
  use SchudeluWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.calendar_index_path(conn, :index))
  end
end
