defmodule Vachan.Massmail do
  use Ash.Api

  resources do
    resource Vachan.Massmail.Campaign
    resource Vachan.Massmail.Message
    resource Vachan.Massmail.Template
    resource Vachan.Massmail.Event
  end
end
