defmodule Vachan.Organizations.Organization do
  use Ash.Resource,
  data_layer: AshPostgres.DataLayer,
  authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:update) do
      authorize_if relates_to_actor_via(:owner)
    end

    actions do
      defaults [:create, :read, :update]
    end

    attributes do
      attribute :id, :uuid do
        primary_key? true
        allow_nil? false
      end

      attribute :name, :string do
        allow_nil? false
        constraints max_length: 64
      end
    end

    postgres do
      table "organizations"
      repo Vachan.Repo
    end

    relationships do
      belongs_to :owner, User do
        api Vachan.Accounts
        source_attribute :id
        destination_attribute :id
      end
    end
end
