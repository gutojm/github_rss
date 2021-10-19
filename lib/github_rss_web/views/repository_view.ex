defmodule GithubRSSWeb.RepositoryView do
  use GithubRSSWeb, :view

  def render("index.json", %{repository: repository}) do
    %{
      id: repository.id,
      user: repository.user,
      repository: repository.repository,
      issues: repository.issues,
      contributors: repository.contributors
    }
  end
end
