defmodule GithubRSS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GithubRSS.Repo,
      # Start the Telemetry supervisor
      GithubRSSWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GithubRSS.PubSub},
      # Start the Endpoint (http/https)
      GithubRSSWeb.Endpoint,
      # Start a worker by calling: GithubRSS.Worker.start_link(arg)
      # {GithubRSS.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubRSS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GithubRSSWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:github_rss, Oban)
  end
end
