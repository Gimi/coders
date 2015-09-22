use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :coders, Coders.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :coders, Coders.Repo,
  database: "coders_test",
  host: System.get_env("RETHINKDB_PORT_28015_TCP_ADDR"),
  port: elem(Integer.parse(System.get_env("RETHINKDB_PORT_28015_TCP_PORT")), 0) # port can only be integer
  name: Coders.Repo
