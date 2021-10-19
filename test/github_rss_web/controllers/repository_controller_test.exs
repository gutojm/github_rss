defmodule GithubRSSWeb.RepositoryControllerTest do
  use GithubRSSWeb.ConnCase
  use Oban.Testing, repo: GithubRSS.Repo

  import Mox

  alias GithubRSS.Jobs.SendWebhookJob

  describe "POST /repository" do
    test "success call", %{conn: conn} do
      expect(GithubRSS.GithubMock, :fetch_issues, fn _, _ ->
        {:ok, [%{}]}
      end)

      expect(GithubRSS.GithubMock, :fetch_contributors, fn _, _ ->
        {:ok, [%{}]}
      end)

      resp =
        post(conn, Routes.repository_path(conn, :create_repository), %{
          user: "teste",
          repository: "teste"
        })
        |> json_response(200)

      assert %{
               "contributors" => [%{}],
               "id" => _,
               "issues" => [%{}],
               "repository" => "teste",
               "user" => "teste"
             } = resp

      assert_enqueued(
        worker: SendWebhookJob,
        args: %{
          "repository" => %{
            "contributors" => [%{}],
            "issues" => [%{}],
            "repository" => "teste",
            "user" => "teste"
          }
        }
      )
    end

    test "error call", %{conn: conn} do
      expect(GithubRSS.GithubMock, :fetch_issues, fn _, _ ->
        {:error, %{body: "Deu tudo errado", status: 400}}
      end)

      resp =
        post(conn, Routes.repository_path(conn, :create_repository), %{
          user: "teste",
          repository: "teste"
        })
        |> json_response(400)

      assert %{"errors" => %{"detail" => "Deu tudo errado"}} = resp

      refute_enqueued(worker: SendWebhookJob)
    end

    test "error call by changeset", %{conn: conn} do
      expect(GithubRSS.GithubMock, :fetch_issues, fn _, _ ->
        {:ok, [%{}]}
      end)

      expect(GithubRSS.GithubMock, :fetch_contributors, fn _, _ ->
        {:ok, [%{}]}
      end)

      resp =
        post(conn, Routes.repository_path(conn, :create_repository), %{})
        |> json_response(422)

      assert %{
               "errors" => %{
                 "detail" => %{"repository" => ["can't be blank"], "user" => ["can't be blank"]}
               }
             } = resp

      refute_enqueued(worker: SendWebhookJob)
    end
  end
end
