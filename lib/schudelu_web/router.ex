defmodule SchudeluWeb.Router do
  use SchudeluWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SchudeluWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SchudeluWeb do
    pipe_through :browser

    get "/", PageController, :index

    #live "/calendar/:calendar_id", Controllers.Calendar
    #live "/calendar-react-ionic/:calendar_id", Controllers.CalendarReactIonic

    live "/calendar", CalendarLive.Index, :index
    live "/calendar/new", CalendarLive.Index, :new
    live "/calendar/:id/edit", CalendarLive.Index, :edit

    live "/calendar/:id", CalendarLive.Show, :show
    live "/calendar/:id/show/edit", CalendarLive.Show, :edit


    live "/event", EventLive.Index, :index
    live "/event/new", EventLive.Index, :new
    live "/event/:id/edit", EventLive.Index, :edit

    live "/event/:id", EventLive.Show, :show
    live "/event/:id/show/edit", EventLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SchudeluWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SchudeluWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
