# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :coders, Coders.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "/ZqgVk7hcomYmlEl0PRKjLxei+gNSCzxFUu3aIqcEqrzELaTR87L1606RjmTNRU+",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Coders.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures the event dispatcher. Mainly registers handlers
# which are interested in the application's events.
# Elements in `:handers` can be in two forms:
# * Just the module name
# * A list of `[module, arg1, arg2, ..., argN]`
config :coders, Coders.EventDispatcher,
  handlers: [
    Coders.Handler.Github
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
