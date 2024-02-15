defmodule Vachan.Repo do
  use Ecto.Repo,
    otp_app: :vachan,
    adapter: Ecto.Adapters.Postgres
end
