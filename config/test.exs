import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :schudelu, Schudelu.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "schudelu_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :schudelu, SchudeluWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fg/cBDzyBTt6fVpQcn6eGmMs6bKauf9W0CvbtLT+Tfq3YnUghI8/6zwhhCqlUB70",
  server: false

# In test we don't send emails.
config :schudelu, Schudelu.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
