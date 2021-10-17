defmodule Repositories.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:github_id, :title, :autor, :labels]
  @required_fields [:github_id, :title, :autor]

  schema "issues" do
    field :github_id, :integer
    field :title, :string
    field :author, :string
    field :labels, :string
    belongs_to :repository, Repositories.Repository
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:github_id)
  end
end
