defmodule GithubRSS.RepositoriesTest do
  use GithubRSS.DataCase

  alias GithubRSS.Repositories

  describe "get/2" do
    test "with result" do
      {:ok, repository} = repository_factory("user_test", "repository_test")

      assert ^repository = Repositories.get("user_test", "repository_test")
    end

    test "without result" do
      assert nil == Repositories.get("user_test", "repository_test")
    end
  end

  describe "upsert/3" do
    test "with previous repository" do
      assert {:ok, %{issues: [%{}]} = repository} =
               repository_factory("user_test", "repository_test")

      assert {:ok, %{issues: [%{"test" => "key"}]}} =
               Repositories.upsert("user_test", "repository_test",
                 issues: [%{"test" => "key"}],
                 contributors: repository.contributors
               )
    end

    test "without previous repository" do
      assert nil == Repositories.get("user_test", "repository_test")

      assert {:ok,
              %{
                user: "user_test",
                repository: "repository_test",
                issues: [%{"test" => "key"}]
              }} =
               Repositories.upsert("user_test", "repository_test",
                 issues: [%{"test" => "key"}],
                 contributors: [%{}]
               )
    end
  end

  defp repository_factory(user, repository) do
    Repositories.upsert(user, repository, issues: [%{}], contributors: [%{}])
  end
end
