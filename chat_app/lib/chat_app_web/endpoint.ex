defmodule ChatAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :chat_app

  # セッション設定
  @session_options [
    store: :cookie,
    key: "_chat_app_key",
    signing_salt: "your_signing_salt",
    same_site: "Lax"
  ]

  # チャットアプリのWebSocket設定
  socket "/socket", ChatAppWeb.UserSocket,
    websocket: true,
    longpoll: true

  # LiveView設定
  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  # LiveReloaderのソケット設定
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket,
      websocket: true,
      longpoll: false
      
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :chat_app,
    gzip: false,
    only: ChatAppWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ChatAppWeb.Router
end
