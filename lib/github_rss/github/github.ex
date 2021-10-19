defmodule GithubRSS.Github do
  @moduledoc """
  Modules responsible for Github wrapper function definitions
  """

  @type result :: {:ok, any} | {:error, any}

  @callback fetch_issues(binary(), binary()) :: result
  @callback fetch_contributors(binary(), binary()) :: result

  @spec adapter :: module()
  defp adapter do
    Application.get_env(:github_rss, GithubRSS.Github)
    |> Keyword.get(:adapter)
  end

  @spec fetch_issues(binary(), binary()) :: result
  def fetch_issues(user, repository) do
    adapter().fetch_issues(user, repository)
  end

  @spec fetch_contributors(binary(), binary()) :: result
  def fetch_contributors(user, repository) do
    adapter().fetch_contributors(user, repository)
  end
end
