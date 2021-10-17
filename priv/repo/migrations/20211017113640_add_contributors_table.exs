defmodule GithubRSS.Repo.Migrations.AddContributorsTable do
  use Ecto.Migration

  def change do
    create table("contributors") do
      add :repository_id,
          references("repositories", on_delete: :delete_all, on_update: :update_all),
          null: false

      add :name, :text, null: false
      add :user, :string, size: 40, null: false
      add :commits, :integer, null: false

      timestamps()
    end

    create unique_index("contributors", [:repository_id, :user])
  end
end
