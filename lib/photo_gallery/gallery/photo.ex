defmodule PhotoGallery.Gallery.Photo do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :photo, PhotoGallery.Photo.Type
    field :uuid, :string

    belongs_to :user, PhotoGallery.Users.User

    timestamps()
  end

  def changeset(image, attrs) do
    image
    |> Map.update(:uuid, Ecto.UUID.generate, fn val -> val || Ecto.UUID.generate end)
    |> cast_attachments(attrs, [:photo])
    |> validate_required([:photo])
  end
end
