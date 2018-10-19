use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :taskmaster, TaskmasterWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :taskmaster, Taskmaster.Repo,
  username: "taskmaster",
  password: "12345",
  database: "taskmaster_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
