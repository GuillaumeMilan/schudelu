defmodule SchudeluWeb.PageController do
  use SchudeluWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
