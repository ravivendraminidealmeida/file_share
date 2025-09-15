defmodule FileShareWeb.PageController do
  use FileShareWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
