import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :github_rss, GithubRSS.Repo,
  username: "postgres",
  password: "postgres",
  database: "github_rss_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :github_rss, GithubRSSWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZzJSRbzvk58mBGcNaUaIU7vnl3Q97YEJnE+M8kolLrCsXf36+UNdF4ntI87Ul3/c",
  server: false

config :github_rss, GithubRSS.Github, adapter: GithubRSS.GithubMock
config :github_rss, GithubRSS.Webhook, adapter: GithubRSS.WebhookMock

# In test we don't send emails.
config :github_rss, GithubRSS.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :github_rss, Oban, queues: false, plugins: false
