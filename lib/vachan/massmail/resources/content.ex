defmodule Vachan.Massmail.Content do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Content of a campaign goes here."
  end

  postgres do
    table "campaign_content"
    repo Vachan.Repo
  end

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  code_interface do
    define_for Vachan.Massmail

    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:read, :destroy]

    read :by_id do
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  @possible_kinds [:plain_text, :rich_text, :mjml]

  attributes do
    integer_primary_key :id
    attribute :reply_to_email, :string, allow_nil?: true
    attribute :reply_to_name, :string, allow_nil?: true

    attribute :kind, :atom do
      constraints one_of: @possible_kinds
    end

    attribute :subject, :string, allow_nil?: false
    attribute :text_body, :string, allow_nil?: false
  end

  relationships do
    belongs_to :campaign, Vachan.Massmail.Campaign

    belongs_to :organization, Vachan.Organizations.Organization do
      api Vachan.Organizations
    end
  end
end
