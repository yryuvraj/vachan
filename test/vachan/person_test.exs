defmodule Vachan.PersonTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Crm

  describe "person creation" do
    @valid_attrs %{
      "email" => "someone@something.com",
      "first_name" => "Some",
      "last_name" => "One"
    }

    @update_attrs %{
      "email" => "anotherone@somethingelse.com",
      "first_name" => "Another",
      "last_name" => "One"
    }

    @invalid_attrs %{
      "email" => "notanemail",
      "first_name" => "Not",
      "last_name" => "AnEmail"
    }

    test "should be created with valid attributes" do
      person = create_person(@valid_attrs, :no_user)

      assert person.first_name == @valid_attrs["first_name"]
      assert person.last_name == @valid_attrs["last_name"]
      assert person.email |> to_string == @valid_attrs["email"]
    end
  end

  defp create_person(attrs, user) do
    {:ok, person} =
      Crm.Person
      |> Ash.Changeset.for_create(:create, attrs)
      |> Crm.create()

    person
  end
end
