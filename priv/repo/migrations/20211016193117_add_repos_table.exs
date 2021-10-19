defmodule GithubRSS.Repo.Migrations.AddReposTable do
  use Ecto.Migration

  def change do
    create table("repositories") do
      add :user, :string, size: 40, null: false
      add :repository, :string, size: 40, null: false
      add :issues, {:array, :jsonb}
      add :contributors, {:array, :jsonb}

      timestamps()
    end

    create unique_index("repositories", [:user, :repository])
  end
end
