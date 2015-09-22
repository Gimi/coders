use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :coders, Coders.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [npm: ["run", "watch"]]

# Watch static and templates for browser reloading.
config :coders, Coders.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :coders, Coders.Repo,
  database: "coders",
  host: System.get_env("RETHINKDB_PORT_28015_TCP_ADDR"),
  port: elem(Integer.parse(System.get_env("RETHINKDB_PORT_28015_TCP_PORT")), 0) # port can only be integer
  #host: "localhost",
  #port: 32769
