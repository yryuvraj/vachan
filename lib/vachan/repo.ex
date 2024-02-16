defmodule Vachan.Repo do
  use AshPostgres.Repo, otp_app: :vachan

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
