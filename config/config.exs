# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :taskmaster,
  ecto_repos: [Taskmaster.Repo]

# Configures the endpoint
config :taskmaster, TaskmasterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sf90P+ZE1pD/I1u4ai3JHM+4s+0YFF1P8EH7CJTjvQ0iLyJ8UToI1R+AxnWtlWs+",
  render_errors: [view: TaskmasterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Taskmaster.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
