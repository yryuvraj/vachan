defmodule VachanWeb.PersonLive.AddToListComponent do
  use VachanWeb, :live_component

  alias Vachan.Crm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add a person to list
      </.header>
      <.table id="add-to-list-table" rows={@lists}>
        <:col :let={{_id, list}} label="List name"><%= list.name %></:col>
      </.table>
    </div>
    """
  end

  @impl true
  def handle_event("add_to_list", %{"person_id" => person_id, "list_id" => list_id}, socket) do
    person = Crm.Person.get_by_id!(person_id)
    list = Crm.List.get_by_id!(list_id)

    {:ok, _} = Crm.List.add_person(list, person)

    {:noreply, socket}
  end
end
