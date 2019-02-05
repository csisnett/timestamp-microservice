defmodule TimestampWeb.Router do
  use TimestampWeb, :router

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

  scope "/", TimestampWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/timestamp", TimestampWeb do
    pipe_through :api

    get "/:date", DateController, :show
    get "/", CurrentTimeController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimestampWeb do
  #   pipe_through :api
  # end
end