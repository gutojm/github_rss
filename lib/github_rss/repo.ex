defmodule GithubRSS.Repo do
  use Ecto.Repo,
    otp_app: :github_rss,
    adapter: Ecto.Adapters.Postgres
end
