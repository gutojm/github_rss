defmodule Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:user, :repository]

  schema "repositories" do
    field :user, :string
    field :repository, :string
    has_many :issues, Repositories.Issue
    has_many :contributors, Repositories.Contributor
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint(@fields)
  end
end
