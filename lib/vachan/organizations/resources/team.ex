defmodule Vachan.Organizations.Team do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:update) do
      authorize_if relates_to_actor_via(:member)
    end

    policy action_type(:read) do
      authorize_if relates_to_actor_via(:member)
    end

  end

  actions do
    defaults [:create, :read, :update]
  end

  @possible_roles = ["admin", "member", "owner"]

  attributes do
    attribute :id, :uuid do
      primary_key? true
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? false
      constraints max_length: 64
    end

    attribute :role, :string do
      allow_nil? false
      constraints one_of: @possible_roles
    end

    attribute :created_at, :utc_datetime do
      allow_nil? false
    end
    attribute :updated_at, :utc_datetime do
      allow_nil? false
    end


  end

  postgres do
    table "teams"
    repo Vachan.Repo
  end

  relationships do
    belongs_to :member, Vachan.Accounts.User do
      api Vachan.Accounts
      source_attribute :id
      destination_attribute :id
    end

    belongs_to :organization, Vachan.Organizations.Organization do
      source_attribute :id
      destination_attribute :id
    end
  end
end
