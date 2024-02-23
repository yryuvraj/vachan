defmodule Vachan.Crm.PersonList do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "PeopleList is a list of people."
  end

  postgres do
    table "crm_people_lists"
    repo Vachan.Repo
  end

  relationships do
    belongs_to :person, Vachan.Crm.Person, primary_key?: true, allow_nil?: false
    belongs_to :list, Vachan.Crm.List, primary_key?: true, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end
end
