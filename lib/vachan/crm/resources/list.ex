defmodule Vachan.Crm.List do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Allow segmenting of people to target for specific campaigns."
  end

  postgres do
    table "crm_lists"
    repo Vachan.Repo
  end

  code_interface do
    define_for Vachan.Crm

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
  end

  relationships do
    many_to_many :lists, Vachan.Crm.List do
      through Vachan.Crm.PersonList
      source_attribute_on_join_resource :list_id
      destination_attribute_on_join_resource :person_id
    end
  end
end
