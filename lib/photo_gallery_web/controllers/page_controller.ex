defmodule PhotoGalleryWeb.PageController do
  use PhotoGalleryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
