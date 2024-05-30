defmodule Vachan.Prelaunch do
  use Ash.Domain

  resources do
    resource Vachan.Prelaunch.Subscriber
  end
end
