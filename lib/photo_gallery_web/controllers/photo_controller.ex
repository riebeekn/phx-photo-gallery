defmodule PhotoGalleryWeb.PhotoController do
  use PhotoGalleryWeb, :controller

  alias PhotoGallery.Gallery
  alias PhotoGallery.Gallery.Photo

  action_fallback PhotoGalleryWeb.FallbackController

  def index(conn, _params) do
    photos = Gallery.list_photos()
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Gallery.change_photo(%Photo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"photos" => photo_params}) do
    with :ok <- Gallery.create_photos(conn.assigns.current_user, photo_params) do
      conn
      |> put_flash(:info, "Upload successful.")
      |> redirect(to: Routes.photo_path(conn, :index))
    end
  end

  def create(conn, params) do
    msg = if (Map.get(params, "photo") == nil) do
      "No photo selected"
    else
      "Please try again, something went wrong"
    end

    conn
    |> put_flash(:info, msg)
    |> redirect(to: Routes.photo_path(conn, :new))
  end

  def show(conn, %{"id" => id}) do
    photo = Gallery.get_photo!(id)
    render(conn, "show.html", photo: photo)
  end

  def delete(conn, %{"id" => id}) do
    photo = Gallery.get_photo!(id)

    with {:ok, _photo} <- Gallery.delete_photo(conn.assigns.current_user, photo) do
      conn
      |> put_flash(:info, "Photo deleted successfully.")
      |> redirect(to: Routes.photo_path(conn, :index))
    end
  end
end
