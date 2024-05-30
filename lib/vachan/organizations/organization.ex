defmodule Vachan.Organizations do
  use Ash.Domain, otp_app: :vachan

  resources do
    resource Vachan.Organizations.Team
    resource Vachan.Organizations.Organization
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
