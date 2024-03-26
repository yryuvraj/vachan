defmodule Vachan.Repo.Migrations.Timestamps do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:campaigns) do
      modify :reply_to_name, :text, null: true
      modify :reply_to_email, :text, null: true
    end
  end

  def down do
    alter table(:campaigns) do
      modify :reply_to_email, :text, null: false
      modify :reply_to_name, :text, null: false
    end
  end
end