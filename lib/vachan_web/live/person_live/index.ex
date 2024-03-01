defmodule VachanWeb.PersonLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm
  alias Vachan.Crm.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, people} = Person.read_all()
    {:ok, stream(socket, :people, people)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Person.get_by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({VachanWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply, stream_insert(socket, :people, person)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Person.get_by_id!(id)
    {:ok, _} = Person.destroy(person)

    {:noreply, stream_delete(socket, :people, person)}
  end
end
