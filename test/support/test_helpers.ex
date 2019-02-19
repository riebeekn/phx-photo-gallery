defmodule PhotoGallery.TestHelpers do
  alias PhotoGallery.{Repo, Users.User, Gallery.Photo}

  def user_fixture(attrs \\ %{}) do
    params =
      attrs
      |> Enum.into(%{
        email: "bob#{System.unique_integer([:positive])}@example.com",
        password: "abcdefghijk",
        confirm_password: "abcdefghijk",
        password_hash: "abcdefghijk",
        is_admin: true
      })

    {:ok, user} =
      User.changeset(%User{}, params)
      |> Repo.insert()

    user
  end

  def photo_fixture(attrs \\ %{}, user \\ user_fixture()) do
    params =
      attrs
      |> Enum.into(%{
        "photo" => %Plug.Upload {
          content_type: "image/jpeg",
          filename: "test_photo.jpeg",
          path: "test/support/assets/test_photo.jpeg"
        }
      })

    {:ok, photo} =
      Photo.changeset(%Photo{}, params)
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()

    photo
  end
end
