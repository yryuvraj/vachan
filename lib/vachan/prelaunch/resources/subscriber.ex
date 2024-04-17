defmodule Vachan.Prelaunch.Subscriber do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  resource do
    description "A subscriber is a person who has signed up for the prelaunch notifications"
  end

  postgres do
    table "subscribers"
    repo Vachan.Repo
  end

  pub_sub do
    module VachanWeb.Endpoint
    prefix "subscriber"
    broadcast_type :phoenix_broadcast

    publish :create, ["created"]
    publish :update, ["updated"]
    publish :destroy, ["destroyed"]
  end

  code_interface do
    define_for Vachan.Prelaunch

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

  identities do
    identity :unique_email, [:email]
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      constraints(match: ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    end

    attribute :name, :string, allow_nil?: false

    attribute :join_beta_tester, :boolean, allow_nil?: false, default: false
    attribute :subscribe_newsletter, :boolean, allow_nil?: false, default: false

    create_timestamp :created_at
    update_timestamp :updated_at
  end
end
