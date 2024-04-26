defmodule Vachan.MultitenancyTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Organizations
  import Vachan.AccountsFixtures

  describe "tenant creation" do
    @valid_attrs %{
      "name" => "Nice Name",
      "subdomain" => "nice-name"
    }

    @update_attrs %{
      "name" => "Updated Name",
      "subdomain" => "updated-name"
    }

    @invalid_attrs %{
      "subdomain" => "bad_subdomain"
    }

    # What do we have to test?
    # - Default organization creation for every user.
    # - Every user should be able to create more orgs.
    # - Every user should be able to add / invite more users to their team.
    # - Campaign / CRM.Person / Lists should all belong to an org's team
    # - A user should not be able to access records of another org.

    test "should be created with valid attributes" do
    end
  end
end
