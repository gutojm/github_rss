defmodule GithubRSS.Github.Api do
  @moduledoc """
  Real implementation
  """

  use Tesla, only: [:get], docs: false

  require Logger

  @behaviour GithubRSS.Github

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/repos/"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"user-agent", "GithubRSS"}]

  @impl true
  def fetch_issues(user, repository) do
    path = "/#{user}/#{repository}/issues"

    Logger.info("Calling Github issues API in path: #{path}")

    path
    |> get()
    |> handle_request()
  end

  @impl true
  def fetch_contributors(user, repository) do
    path = "/#{user}/#{repository}/contributors"

    Logger.info("Calling Github contributors API in path: #{path}")

    path
    |> get()
    |> handle_request()
  end

  defp handle_request(request) do
    case request do
      {:ok, %{body: body, status: status}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{body: body} = request} ->
        Logger.warn(inspect(body, pretty: true))

        {:error, request}

      error ->
        Logger.error(inspect(error, pretty: true))

        error
    end
  end
end
