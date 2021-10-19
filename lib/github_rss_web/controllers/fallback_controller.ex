defmodule GithubRSSWeb.FallbackController do
  @moduledoc """
  Fallback controller
  """
  use GithubRSSWeb, :controller

  require Logger

  alias GithubRSSWeb.ErrorView

  def call(conn, {:error, %{status: status, body: body}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render(:"#{status}", body: body)
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_changeset_error(changeset))
  end

  def call(conn, {:error, reason}) do
    Logger.error("Generic error view called, reason #{inspect(reason, pretty: true)}")

    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render(:"500")
  end
end
