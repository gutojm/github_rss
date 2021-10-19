defmodule GithubRSS.SendWebhookJobTest do
  @moduledoc false
  use GithubRSS.DataCase
  use Oban.Testing, repo: GithubRSS.Repo

  import Mox

  alias GithubRSS.{Jobs.SendWebhookJob, Repositories}

  describe "perform/2" do
    test "succesfull perform" do
      expect(GithubRSS.WebhookMock, :send_to_webhook, fn _ ->
        {:ok, "Sent"}
      end)

      repository =
        repository_factory("user_test", "repository_test")
        |> Map.take([:user, :repository, :issues, :contributors])

      assert {:ok, "Sent"} = perform_job(SendWebhookJob, %{"repository" => repository})
    end

    test "succesfull perform without args" do
      expect(GithubRSS.WebhookMock, :send_to_webhook, fn _ ->
        {:ok, "Sent"}
      end)

      repository =
        repository_factory("user_test", "repository_test")
        |> Map.take([:user, :repository])
        |> Map.merge(%{issues: [%{}], contributors: [%{}]})

      assert {:ok, "Sent"} = perform_job(SendWebhookJob, %{"repository" => repository})
    end

    test "error perform" do
      expect(GithubRSS.WebhookMock, :send_to_webhook, fn _ ->
        {:error, %{body: "Deu tudo errado", status: 400}}
      end)

      repository =
        repository_factory("user_test", "repository_test")
        |> Map.take([:user, :repository])
        |> Map.merge(%{issues: [%{}], contributors: [%{}]})

      assert {:error, %{body: "Deu tudo errado", status: 400}} = perform_job(SendWebhookJob, %{"repository" => repository})
    end
  end

  defp repository_factory(user, repository) do
    Repositories.upsert(user, repository,
      issues: [
        %{
          "title" => "title_test",
          "labels" => ["label_test"],
          "user" => %{"login" => "author_test"}
        }
      ],
      contributors: [
        %{
          "login" => "user_test",
          "contributions" => 1
        }
      ]
    )
    |> elem(1)
  end
end
