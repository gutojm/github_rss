defmodule GithubRSS.Repositories do
  @moduledoc """
  Context Repositories module
  """

  alias GithubRSS.{Repo, Repositories.Repository}

  @spec get(binary(), binary()) :: nil | Repository.t()
  def get(user, repository) do
    Repo.get_by(Repository, user: user, repository: repository)
  end

  def upsert(user, repository, issues: issues, contributors: contributors) do
    %Repository{}
    |> Repository.changeset(%{
      user: user,
      repository: repository,
      issues: issues,
      contributors: contributors
    })
    |> Repo.insert(
      on_conflict: [set: [issues: issues, contributors: contributors]],
      conflict_target: [:user, :repository],
      returning: true
    )
  end
end
