# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :photo_gallery,
  ecto_repos: [PhotoGallery.Repo]

# Configures the endpoint
config :photo_gallery, PhotoGalleryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mNEnJwTyoHGmnH+1bgZ4KoMDsUdw5KH0x4jdZvKQGtGadrL4lj0YXHTJwYD3L5nL",
  render_errors: [view: PhotoGalleryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhotoGallery.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Pow configuration
config :photo_gallery, :pow,
  user: PhotoGallery.Users.User,
  repo: PhotoGallery.Repo,
  web_module: PhotoGalleryWeb,
  extensions: [PowPersistentSession, PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: PhotoGalleryWeb.Pow.Mailer,
  routes_backend: PhotoGalleryWeb.Pow.Routes,
  messages_backend: PhotoGalleryWeb.Pow.Messages

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
