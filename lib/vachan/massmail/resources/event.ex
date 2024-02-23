defmodule Vachan.Massmail.Event do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Track when the emails were opened, clicked, bounced or reported."
  end

  postgres do
    table "massmail_events"
    repo Vachan.Repo
  end

  code_interface do
    define_for Vachan.Massmail

    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  relationships do
    belongs_to :message, Vachan.Massmail.Message
  end

  attributes do
    integer_primary_key :id

    attribute :type, :string, allow_nil?: false

    attribute :created_at, :utc_datetime_usec do
      writable? false
      default &DateTime.utc_now/0
      match_other_defaults? true
      allow_nil? false
    end
  end
end
