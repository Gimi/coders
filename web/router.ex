defmodule Coders.Router do
  use Coders.Web, :router

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

  scope "/", Coders do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Coders.API, as: :api do
    pipe_through :api

    resources "github_users", GithubUserController, only: [:index, :show, :create, :delete]
  end
end
