defmodule GithubRSS.Repo.Migrations.AddReposTable do
  use Ecto.Migration

  def up do
    create table("repo") do
      add :user,    :string, size: 40
      add :repository, :string, size: 40

      timestamps()
    end

    unique_index("repo", [:user, :repository])
  end

  def down do
    drop table("repo")
  end
end
