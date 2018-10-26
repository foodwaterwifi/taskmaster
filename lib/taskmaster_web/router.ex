defmodule TaskmasterWeb.Router do
  use TaskmasterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TaskmasterWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ajax do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug TaskmasterWeb.Plugs.FetchSession # FIXME: "FetchUser"
  end

  scope "/ajax", TaskmasterWeb do
    pipe_through :ajax
    resources "/time-blocks", TimeBlockController
  end

  scope "/", TaskmasterWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController do
      get "/report", UserController, :report, as: :report
    end
    resources "/tasks", TaskController
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskmasterWeb do
  #   pipe_through :api
  # end
end
