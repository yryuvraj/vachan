defmodule Vachan.Accounts do
  use Ash.Api

  resources do
    resource Vachan.Accounts.User
    resource Vachan.Accounts.Token
  end
end
