defmodule GithubRSS.Repo.Migrations.AddIssuesTable do
  use Ecto.Migration

  def change do
    create table("issues") do
      add :repository_id,
          references("repositories", on_delete: :delete_all, on_update: :update_all),
          null: false

      add :github_id, :integer, null: false
      add :title, :string, size: 60, null: false
      add :author, :string, size: 40, null: false
      add :labels, :text

      timestamps()
    end

    create unique_index("issues", :github_id)
  end
end
