defmodule Schudelu.Repo do
  use Ecto.Repo,
    otp_app: :schudelu,
    adapter: Ecto.Adapters.Postgres
end
