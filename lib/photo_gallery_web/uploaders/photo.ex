defmodule PhotoGallery.Photo do
  use Arc.Definition
  use Arc.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Set permissions to public read for uploaded files
  @acl :public_read

  # Whitelist file extensions:
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150"}
  end

  # Override the persisted filenames:
  def filename(version, {file, scope}) do
    "#{scope.uuid}_#{version}"
  end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do
    "uploads/photos/"
  end
end
