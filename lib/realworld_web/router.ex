defmodule RealworldWeb.Router do
  use RealworldWeb, :router

  #
  # Pipelines
  #
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RealworldWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  #
  # Basic scope
  #
  scope "/", RealworldWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  #
  # Scope API
  #
  scope "/api", RealworldWeb do
    pipe_through :api

    #
    # Users routes
    get "/users/", UsersController, :user_list
    get "/users/:userId", UsersController, :user_by_id
    put "/users/", UsersController, :update_user

    #
    # Articles routes
    get "/articles", ArticlesController, :article_list
    get "/articles/feed", ArticlesController, :article_feed
    get "/articles/:slug", ArticlesController, :article_by_slug

    post "/articles", ArticlesController, :create_article
    put "/articles/:slug", ArticlesController, :update_article
    delete "/articles/:slug", ArticlesController, :delete_article

  end

  #
  # Dashboard (Dev mode only)
  #
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RealworldWeb.Telemetry
    end
  end
end
