defmodule PhotoGalleryWeb.FallbackController do
  use PhotoGalleryWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(PhotoGalleryWeb.ErrorView)
    |> render(:"403")
  end
end
