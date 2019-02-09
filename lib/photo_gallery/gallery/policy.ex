defmodule PhotoGallery.Gallery.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:delete_photo, user, photo), do: user.id == photo.user_id
end
