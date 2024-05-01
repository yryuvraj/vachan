defmodule VachanWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides
  alias AshAuthentication.Phoenix.Components

  override Components.Banner do
    set :image_url, "/images/vaak-logo.svg"
    set :image_class, "object-scale-down object-top h-48 w-96" # Adjust size and position here
    #absolute top-20px left-auto
  end
end                  