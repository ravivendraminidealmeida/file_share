defmodule FileShare.Repo do
  use Ecto.Repo,
    otp_app: :file_share,
    adapter: Ecto.Adapters.SQLite3
end
