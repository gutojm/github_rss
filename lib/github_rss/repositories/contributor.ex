defmodule Repositories.Contributor do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :user, :commits]

  schema "contributors" do
    field :name, :string
    field :user, :string
    field :commits, :integer
    belongs_to :repository, Repositories.Repository
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:repository_id, :user])
  end
end
