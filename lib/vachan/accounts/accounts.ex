defmodule Vachan.Accounts do
  use Ash.Domain

  resources do
    resource Vachan.Accounts.User
    resource Vachan.Accounts.Token
  end
end
