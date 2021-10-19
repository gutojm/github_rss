defmodule GithubRSS.Jobs.SendWebhookJob do
  @moduledoc false
  use Oban.Worker

  alias GithubRSS.Webhook

  @impl true
  def perform(%Oban.Job{args: %{"repository" => repository}}) do
    repository
    |> build_hook_body()
    |> send_to_webhook()
  end

  defp build_hook_body(%{"issues" => issues, "contributors" => contributors} = payload) do
    issue_list =
      Enum.map(issues, fn
        %{"labels" => labels, "title" => title, "user" => %{"login" => login}} ->
          %{"labels" => labels, "title" => title, "author" => login}

        _ ->
          %{}
      end)

    contributor_list =
      Enum.map(contributors, fn
        %{"login" => login, "contributions" => contributions} ->
          %{"name" => login, "user" => login, "qtd_commits" => contributions}

        _ ->
          %{}
      end)

    %{payload | "issues" => issue_list, "contributors" => contributor_list}
  end

  defp send_to_webhook(body) do
    Webhook.send_to_webhook(body)
  end
end
