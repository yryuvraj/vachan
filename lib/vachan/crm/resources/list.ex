defmodule Vachan.Crm.List do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  resource do
    description "Allow segmenting of people to target for specific campaigns."
  end

  postgres do
    table "crm_lists"
    repo Vachan.Repo
  end

  pub_sub do
    module VachanWeb.Endpoint
    prefix "list"
    broadcast_type :phoenix_broadcast

    publish :create, ["created"]
    publish :update, ["updated"]
    publish :destroy, ["destroyed"]
  end

  code_interface do
    define_for Vachan.Crm

    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
    define :add_person, args: [:person_id], action: :add_person
    define :remove_person, args: [:person_id], action: :remove_person
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    update :add_person do
      argument :person_id, :uuid, allow_nil?: false

      change manage_relationship(:person_id, :people, type: :append)
    end

    update :remove_person do
      argument :person_id, :uuid, allow_nil?: false

      change manage_relationship(:person_id, :people, type: :remove)
    end

    read :by_id do
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    many_to_many :people, Vachan.Crm.Person do
      through Vachan.Crm.PersonList
      source_attribute_on_join_resource :list_id
      destination_attribute_on_join_resource :person_id
    end
  end

  identities do
    identity :unique_list_name, [:name]
  end
end
