defmodule Timestamp.Repo do
  use Ecto.Repo,
    otp_app: :timestamp,
    adapter: Ecto.Adapters.Postgres
end
