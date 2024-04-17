defmodule Vachan.Prelaunch do
  use Ash.Api

  resources do
    resource Vachan.Prelaunch.Subscriber
  end
end
