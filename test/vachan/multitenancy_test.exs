defmodule Vachan.MultitenancyTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Organization

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

    test "should be created with valid attributes" do
      tenant = create_tenant(@valid_attrs, :no_user)

      assert tenant.name == @valid_attrs["name"]
      assert tenant.subdomain == @valid_attrs["subdomain"]
    end

    test "should not be created with invalid attributes" do
      assert_raise Ash.Error.Invalid, fn -> create_tenant(@invalid_attrs, :no_user) end
    end
  end

  defp create_tenant(attrs, user) do
    Organization.Tenant
    |> Ash.Changeset.for_create(:create, Map.put(attrs, "id", user.id), actor: user)
    |> Organization.create!()
  end


end
