Mox.defmock(GithubRSS.GithubMock, for: GithubRSS.Github)
Mox.defmock(GithubRSS.WebhookMock, for: GithubRSS.Webhook)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GithubRSS.Repo, :manual)
