defmodule Vachan.Massmail.Campaign do
  use Ash.Resource,
    domain: Vachan.Massmail,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshStateMachine]

  resource do
    description "Campaigns are used to send mass emails to a list of recipients."
  end

  state_machine do
    initial_states([:new])
    default_initial_state(:new)

    transitions do
      transition(:add_content, from: :new, to: :content_added)
      transition(:add_recepients, from: :content_added, to: :recepients_added)
      transition(:associate_sender_profile, from: :recepients_added, to: :sender_added)
      transition(:send_test_mail, from: :sender_added, to: :test_mail_sent)
      transition(:start_sending, from: :test_mail_sent, to: :sending_started)
      transition(:error, from: [:sending_started, :new, :sender_added], to: :error)
      transition(:complete, from: :sending_started, to: :sending_finished)
    end
  end

  postgres do
    table "campaigns"
    repo Vachan.Repo
  end

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  code_interface do
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id

    define :associate_sender_profile,
      args: [:sender_profile_id],
      action: :associate_sender_profile

    define :associate_contact_list, args: [:list_id], action: :associate_contact_list
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true

      accept [
        :name
      ]

      argument :list_id, :integer do
        allow_nil? true
      end

      change manage_relationship(:list_id, :contact_list, type: :append)
    end

    update :update do
      primary? true
      require_atomic? false
      accept [
        :name
      ]

      argument :list_id, :integer do
        allow_nil? false
      end

      change manage_relationship(:list_id, :contact_list, type: :append)
    end

    read :by_id do
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    update :associate_contact_list do
      require_atomic? false
      argument :list_id, :integer, allow_nil?: false
      change manage_relationship(:list_id, :contact_list, on_lookup: :relate, on_no_match: :error)
    end

    update :add_content, do: change(transition_state(:content_added))
    update :add_recepients, do: change(transition_state(:recepients_added))

    update :associate_sender_profile do
      require_atomic? false
      argument :sender_profile_id, :uuid, allow_nil?: false

      change manage_relationship(:sender_profile_id, :sender_profile,
               on_lookup: :relate,
               on_no_match: :error
             )
    end

    update :send_test_mail, do: change(transition_state(:test_mail_sent))
    update :start_sending, do: change(transition_state(:sending_started))
    update :error, do: change(transition_state(:error))
    update :complete, do: change(transition_state(:sending_finished))
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string, allow_nil?: false
    # attribute :slug, :string, allow_nil?: false

    attribute :active?, :boolean, allow_nil?: false, default: true
    attribute :deleted?, :boolean, allow_nil?: false, default: false

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_one :recepients, Vachan.Massmail.Recepients
    has_one :content, Vachan.Massmail.Content
    has_many :messages, Vachan.Massmail.Message

    belongs_to :contact_list, Vachan.Crm.List,
      source_attribute: :list_id,
      domain: Vachan.Crm,
      attribute_type: :integer,
      allow_nil?: true

    belongs_to :organization, Vachan.Organizations.Organization do
      domain(Vachan.Organizations)
      allow_nil? true
    end

    belongs_to :sender_profile, Vachan.SenderProfiles.SenderProfile do
      domain(Vachan.SenderProfiles)
    end
  end

  validations do
    validate match(:sender_email, ~r/^[^\s]+@[^\s]+$/),
      on: [:create, :update],
      message: "Invalid email"
  end
end
