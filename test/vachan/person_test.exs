defmodule Vachan.PersonTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Crm

  import Vachan.AccountsFixtures

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
      user = confirmed_user()
      person = create_person(@valid_attrs, user)

      assert person.first_name == @valid_attrs["first_name"]
      assert person.last_name == @valid_attrs["last_name"]
      assert person.email |> to_string == @valid_attrs["email"]
    end
  end

  defp create_person(attrs, user) do
    {:ok, person} =
      Crm.Person
      |> Ash.Changeset.for_create(:create, attrs, actor: user)
      |> Crm.create()

    person
  end
end
