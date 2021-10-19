defmodule GithubRSS.Webhook do
  @moduledoc """
  Modules responsible for Webhook wrapper function definitions
  """

  @type result :: {:ok, any} | {:error, any}

  @callback send_to_webhook(map()) :: result

  @spec adapter :: module()
  defp adapter do
    Application.get_env(:github_rss, GithubRSS.Webhook)
    |> Keyword.get(:adapter)
  end

  @spec send_to_webhook(map()) :: result
  def send_to_webhook(body) do
    adapter().send_to_webhook(body)
  end
end
