# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :github_rss,
  namespace: GithubRSS,
  ecto_repos: [GithubRSS.Repo]

# Configures the endpoint
config :github_rss, GithubRSSWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GithubRSSWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GithubRSS.PubSub,
  live_view: [signing_salt: "FFQMvHrx"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :github_rss, GithubRSS.Mailer, adapter: Swoosh.Adapters.Local

config :github_rss, GithubRSS.Github, adapter: GithubRSS.Github.Api
config :github_rss, GithubRSS.Webhook, adapter: GithubRSS.Webhook.Api

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :github_rss, Oban,
  repo: GithubRSS.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
