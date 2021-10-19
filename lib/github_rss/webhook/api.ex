defmodule GithubRSS.Webhook.Api do
  @moduledoc """
  Real implementation
  """

  use Tesla, only: [:post], docs: false

  require Logger

  @behaviour GithubRSS.Webhook

  plug Tesla.Middleware.BaseUrl, "https://webhook.site/6e9e702b-81ba-4ef4-857e-e53564046ef6/"
  plug Tesla.Middleware.JSON

  @impl true
  def send_to_webhook(map) do
    Logger.info("Sending data to webhook")

    post("/", map)
    |> handle_request()
  end

  defp handle_request(request) do
    case request do
      {:ok, %{body: body, status: status}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{body: body} = request} ->
        Logger.warn(inspect(body, pretty: true))

        {:error, request}

      error ->
        Logger.error(inspect(error, pretty: true))

        error
    end
  end
end
