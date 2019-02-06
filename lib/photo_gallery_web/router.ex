defmodule PhotoGalleryWeb.Router do
  use PhotoGalleryWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :photo_gallery

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  scope "/", PhotoGalleryWeb do
    pipe_through [:browser, :protected]

    # Add your protected routes here
  end

  scope "/", PhotoGalleryWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
