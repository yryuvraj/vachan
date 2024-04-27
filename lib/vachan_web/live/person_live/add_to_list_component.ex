defmodule VachanWeb.PersonLive.AddToList do
  use VachanWeb, :live_view

  alias Vachan.Crm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add a person to list
      </.header>
      <.table id="add-to-list-table" rows={@lists}>
        <:col :let={list} label="List name"><%= list.name %></:col>
        <:action :let={list}>
          <%= if list.id in @person_lists do %>
            <.link phx-click={
              JS.push("remove_from_list",
                value: %{list_id: list.id, person_id: @person.id}
              )
            }>
              Remove
            </.link>
          <% else %>
            <.link phx-click={
              JS.push("add_to_list",
                value: %{list_id: list.id, person_id: @person.id}
              )
            }>
              Add
            </.link>
          <% end %>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => person_id} = _params, _session, socket) do
    if connected?(socket) do
      VachanWeb.Endpoint.subscribe("person_list:created")
      VachanWeb.Endpoint.subscribe("person_list:destroyed")
    end

    lists = Crm.List.read_all!(ash_opts(socket))
    person = Crm.Person.get_by_id!(person_id, ash_opts(socket))
    person_lists = get_list_ids_for_person(person, socket)

    {:ok,
     socket
     |> assign(lists: lists)
     |> assign(person: person)
     |> assign(:person_lists, person_lists)}
  end

  @impl true
  def handle_event(
        "add_to_list",
        %{"person_id" => person_id, "list_id" => list_id},
        socket
      ) do
    list = Crm.List.get_by_id!(list_id, ash_opts(socket))

    {:ok, _} = Crm.List.add_person(list, person_id, ash_opts(socket))

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "remove_from_list",
        %{"person_id" => person_id, "list_id" => list_id},
        socket
      ) do
    list = Crm.List.get_by_id!(list_id, ash_opts(socket))

    {:ok, _} = Crm.List.remove_person(list, person_id, ash_opts(socket))

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: "person_list:created", payload: _payload}, socket) do
    handle_modification(socket)
  end

  @impl true
  def handle_info(%{topic: "person_list:destroyed", payload: _payload}, socket) do
    handle_modification(socket)
  end

  defp handle_modification(socket) do
    person_lists = get_list_ids_for_person(socket.assigns.person, socket)

    {:noreply,
     socket
     |> assign(:person_lists, person_lists)}
  end

  defp get_list_ids_for_person(person, socket) do
    person
    |> Vachan.Crm.load!(:lists, ash_opts(socket))
    |> then(fn x -> x.lists end)
    |> Enum.map(fn x -> x.id end)
  end
end
