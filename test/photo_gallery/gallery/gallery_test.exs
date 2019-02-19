defmodule PhotoGallery.GalleryTest do
  use PhotoGallery.DataCase

  alias PhotoGallery.Gallery

  setup_all do
    on_exit fn ->
      Application.get_env(:photo_gallery, :upload_dir)
      |> File.rm_rf()
    end
  end

  describe "photos" do
    alias PhotoGallery.Gallery.Photo

    @invalid_attrs %{photo: nil, uuid: nil}
    @valid_attrs %{
      "photo" => %Plug.Upload {
        content_type: "image/jpeg",
        filename: "test_photo.jpeg",
        path: "test/support/assets/test_photo.jpeg"
      }
    }

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      photos = Gallery.list_photos()
      assert Enum.count(photos) == 1
      assert_photo(hd(photos), photo)
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert_photo(Gallery.get_photo!(photo.id), photo)
    end

    test "create_photo/1 with valid data creates a photo" do
      assert {:ok, %Photo{} = photo} =
        Gallery.create_photo(user_fixture(), @valid_attrs)
      assert photo.photo.file_name == "test_photo.jpeg"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Gallery.create_photo(user_fixture(), @invalid_attrs)
    end

    test "delete_photo/1 deletes the photo" do
      user = user_fixture()
      photo = photo_fixture(%{}, user)
      assert {:ok, %Photo{}} = Gallery.delete_photo(user, photo)
      assert_raise Ecto.NoResultsError, fn -> Gallery.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Gallery.change_photo(photo)
    end
  end

  defp assert_photo(left, right) do
    assert left.id == right.id
    assert left.inserted_at == right.inserted_at
    assert left.updated_at == right.updated_at
    assert left.user_id == right.user_id
    assert left.uuid == right.uuid
    assert left.photo.file_name == right.photo.file_name
  end
end
