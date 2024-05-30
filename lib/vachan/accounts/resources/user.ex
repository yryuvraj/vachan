defmodule Vachan.Accounts.User do
  use Ash.Resource,
    domain: Vachan.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  actions do
    defaults [:read, :create]
  end

  changes do
    change after_action(fn changeset, result, context ->
             organization =
               Vachan.Organizations.Organization
               |> Ash.Changeset.for_create(
                 :create,
                 %{
                   name: "personal_" <> result.id
                 },
                 actor: result
               )
               |> Ash.create!(authorize?: true)

             Vachan.Organizations.Team
             |> Ash.Changeset.for_create(
               :create,
               %{role: :owner},
               actor: result
             )
             |> Ash.Changeset.manage_relationship(:member, result, type: :append)
             |> Ash.Changeset.manage_relationship(
               :organization,
               organization,
               type: :append
             )
             |> Ash.create!(authorize?: true)

             {:ok, result}
           end),
           # only do this when a user is created.
           on: [:create]
  end

  authentication do
    domain(Vachan.Accounts)

    add_ons do
      confirmation :confirm do
        monitor_fields([:email])
        sender(Vachan.Accounts.Senders.SendEmailConfirmationEmail)
      end
    end

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true

        resettable do
          sender(Vachan.Accounts.Senders.SendPasswordResetEmail)
        end
      end
    end

    tokens do
      enabled? true
      token_resource Vachan.Accounts.Token

      signing_secret Vachan.Accounts.Secrets
    end
  end

  postgres do
    table "users"
    repo Vachan.Repo
  end

  identities do
    identity :unique_email, [:email] do
      eager_check_with Vachan.Accounts
    end
  end

  validations do
    validate match(:email, ~r/^[^\s]+@[^\s]+$/), on: [:create, :update], message: "invalid email"
  end

  relationships do
    many_to_many :orgs, Vachan.Organizations.Organization do
      through Vachan.Organizations.Team
      domain(Vachan.Organizations)
      source_attribute_on_join_resource :member_id
      destination_attribute_on_join_resource :organization_id
    end

    has_many :orgs_join_assoc, Vachan.Organizations.Team do
      domain(Vachan.Organizations)
      source_attribute :id
      destination_attribute :member_id
    end

    has_one :profile, Vachan.Profiles.Profile do
      domain(Vachan.Profiles)
      source_attribute :id
      destination_attribute :id
    end
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
