defmodule GithubRSS.Repositories.Repository do
  @moduledoc """
  Repository Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @fields [:user, :repository, :issues, :contributors]

  schema "repositories" do
    field :user, :string
    field :repository, :string
    field :issues, {:array, :map}
    field :contributors, {:array, :map}

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint(@fields)
  end
end
