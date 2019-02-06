defmodule PhotoGallery.Repo do
  use Ecto.Repo,
    otp_app: :photo_gallery,
    adapter: Ecto.Adapters.Postgres
end
