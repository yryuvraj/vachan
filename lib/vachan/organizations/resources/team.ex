defmodule Vachan.Organizations.Team do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:update) do
      authorize_if relates_to_actor_via(:member)
    end

    policy action_type(:create) do
      authorize_if always()
    end

    policy action_type(:read) do
      authorize_if relates_to_actor_via(:member)
    end
  end

  actions do
    defaults [:read, :update, :create, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    read :by_org_and_member do
      argument :organization_id, :uuid, allow_nil?: false
      argument :member_id, :uuid, allow_nil?: false
      get? true
      filter expr(organization_id == ^arg(:organization_id) and member_id == ^arg(:member_id))
    end
  end

  code_interface do
    define_for Vachan.Organizations

    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id

    define :get_by_org_and_member,
      args: [:organization_id, :member_id],
      action: :by_org_and_member
  end

  @possible_roles [:admin, :member, :owner]

  attributes do
    uuid_primary_key :id

    attribute :role, :atom do
      allow_nil? false
      constraints one_of: @possible_roles
      default :member
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  postgres do
    table "teams"
    repo Vachan.Repo
  end

  relationships do
    belongs_to :member, Vachan.Accounts.User do
      api Vachan.Accounts
      primary_key? true
      allow_nil? false
    end

    belongs_to :organization, Vachan.Organizations.Organization do
      primary_key? true
      allow_nil? false
    end
  end
end
