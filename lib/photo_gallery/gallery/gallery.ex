defmodule PhotoGallery.Gallery do
  import Ecto.Query, warn: false
  alias PhotoGallery.Users.User
  alias PhotoGallery.Repo
  alias PhotoGallery.Gallery.Photo
  alias PhotoGallery.Gallery.Policy

  defdelegate authorize(action, user, params), to: Policy

  def list_photos do
    Repo.all(Photo)
  end

  def get_photo!(id), do: Repo.get!(Photo, id)

  def create_photo(%User{} = user, attrs \\ %{}) do
    %Photo{}
    |> Photo.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def delete_photo(%User{} = user, %Photo{} = photo) do
    with :ok <- Bodyguard.permit(PhotoGallery.Gallery, :delete_photo, user, photo) do
      PhotoGallery.Photo.delete({photo.photo, photo})
      Repo.delete(photo)
    end
  end

  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end
end
