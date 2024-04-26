defmodule Vachan.Crm do
  use Ash.Api

  resources do
    resource Vachan.Crm.Person
    resource Vachan.Crm.List
    resource Vachan.Crm.PersonList
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
