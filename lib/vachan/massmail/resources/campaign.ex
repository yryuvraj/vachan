defmodule Vachan.Massmail.Campaign do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Campaigns are used to send mass emails to a list of recipients."
  end

  postgres do
    table "campaigns"
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
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string, allow_nil?: false
    # add relationship to message template
    #
  end

  relationships do
    has_many :messages, Vachan.Massmail.Message
    has_many :templates, Vachan.Massmail.Template
    belongs_to :list, Vachan.Crm.List, api: Vachan.Crm, attribute_type: :integer

    end
  end
