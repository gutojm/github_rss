defmodule GithubRSSWeb.RepositoryController do
  use GithubRSSWeb, :controller

  alias GithubRSS.Github
  alias GithubRSS.Repositories
  alias GithubRSS.Jobs.SendWebhookJob

  def create_repository(conn, params) do
    with {:ok, issues} <- Github.fetch_issues(params["user"], params["repository"]),
         {:ok, contributors} <- Github.fetch_contributors(params["user"], params["repository"]),
         {:ok, repository} <-
           Repositories.upsert(params["user"], params["repository"],
             issues: issues,
             contributors: contributors
           ) do
      schedule_webhook_job(repository)

      conn
      |> put_status(:ok)
      |> render("index.json", repository: repository)
    end
  end

  defp schedule_webhook_job(repository) do
    repository_state =
      repository
      |> Map.take([:user, :repository, :issues, :contributors])

    %{repository: repository_state}
    |> SendWebhookJob.new(schedule_in: 86_400)
    |> Oban.insert()
  end
end
