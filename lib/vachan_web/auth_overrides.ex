defmodule VachanWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides
  alias AshAuthentication.Phoenix.Components

  override Components.Banner do
    set :image_url, "/images/vaak-logo.svg"
    # Adjust size and position here
    set :image_class, "object-scale-down object-top h-48 w-96"
    # absolute top-20px left-auto
  end
end
