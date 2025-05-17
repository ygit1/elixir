import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chat_app, ChatAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "MDOveQN8PixvMTy4psOCFvW7o2oWMi12mV5K5So/01Suyg9GRkowaG2cLoJlyFZC",
  server: false

# In test we don't send emails
config :chat_app, ChatApp.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :chat_app, ChatApp.Repo,
  database: Path.expand("../chat_app_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  adapter: Ecto.Adapters.SQLite3
