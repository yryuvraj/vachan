defmodule Vachan.Crm.PersonList do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  resource do
    description "PeopleList is a list of people."
  end

  postgres do
    table "crm_people_lists"
    repo Vachan.Repo

    references do
      reference :person, on_delete: :delete
      reference :list, on_delete: :delete
    end
  end

  relationships do
    belongs_to :person, Vachan.Crm.Person, primary_key?: true, allow_nil?: false

    belongs_to :list, Vachan.Crm.List,
      primary_key?: true,
      allow_nil?: false,
      attribute_type: :integer
  end

  pub_sub do
    module VachanWeb.Endpoint
    prefix "person_list"
    broadcast_type :phoenix_broadcast

    publish :create, ["created"]
    publish :create, ["created", "person_id", "list_id"]
    publish :update, ["updated"]
    publish :destroy, ["destroyed"]
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
