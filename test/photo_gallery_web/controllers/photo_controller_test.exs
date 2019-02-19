defmodule PhotoGalleryWeb.PhotoControllerTest do
  use PhotoGalleryWeb.ConnCase

  alias PhotoGallery.Gallery

  @invalid_attrs %{photo: nil}
  @create_attrs %{
    "photos" => [
      %Plug.Upload {
        content_type: "image/jpeg",
        filename: "test_photo.jpeg",
        path: "test/support/assets/test_photo.jpeg"
      }
    ]
  }

  setup_all do
    on_exit fn ->
      Application.get_env(:photo_gallery, :upload_dir)
      |> File.rm_rf()
    end
  end

  setup %{conn: conn} do
    user = user_fixture()
    conn = assign(conn, :current_user, user)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all photos", %{conn: conn} do
      conn = get(conn, Routes.photo_path(conn, :index))
      assert html_response(conn, 200) =~ "Add new photo"
    end
  end

  describe "new photo" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.photo_path(conn, :new))
      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "create photo" do
    test "redirects to show when data is valid", %{conn: conn} do
      create_conn = post(conn, Routes.photo_path(conn, :create), photos: @create_attrs)
      assert redirected_to(create_conn) == Routes.photo_path(create_conn, :index)

      photo = hd(Gallery.list_photos())
      show_conn = get(conn, Routes.photo_path(conn, :show, photo.id))
      assert html_response(show_conn, 200) =~ photo.uuid
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.photo_path(conn, :create), photo: @invalid_attrs)
      assert redirected_to(conn) == Routes.photo_path(conn, :new)
    end
  end

  describe "delete photo" do
    test "deletes chosen photo", %{conn: conn} do
      # need to assign the current user to the photo so delete is allowed
      user = user_fixture()
      photo = photo_fixture(%{}, user)
      conn = assign(conn, :current_user, user)

      delete_conn = delete(conn, Routes.photo_path(conn, :delete, photo))
      assert redirected_to(delete_conn) == Routes.photo_path(delete_conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.photo_path(conn, :show, photo))
      end
    end
  end
end
