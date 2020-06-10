# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :xby_status, XbyStatusWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OLQaaDUmCkDeisWRVR8aY+DHhSMRT4U3MQAyUbUCYug0jebyiz3FOOB80uf4lOJF",
  render_errors: [view: XbyStatusWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: XbyStatus.PubSub,
  live_view: [signing_salt: "/b6ZauRK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :xby_status,
  eth: %{address: "0x6bdc9b226235df1182443701e0d0f8b5b97d7ff5", api_key: "8MWB9TPXYWYCB2NA91GCVHHIDYXN94EY7V"},
  btc: %{address: "1KVQsBCbYziXWfFh1Av7nZy359vUHxddxS"},
  xby: %{address: "BPZ3cwCgdRngbQa9h28C89crxqkyT5oQHy"},
  xfuel: %{address: "F6vMdDCBnK7CVEgkuQTRBNfA8Ji3K43x4U"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
