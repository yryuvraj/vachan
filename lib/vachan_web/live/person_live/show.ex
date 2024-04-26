defmodule VachanWeb.PersonLive.Show do
  use VachanWeb, :live_view

  alias Vachan.Crm

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def ash_opts(socket, opts \\ []) do
    Keyword.merge(
      [actor: socket.assigns[:current_user], tenant: socket.assigns[:current_org].id],
      opts
    )
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person, Crm.Person.get_by_id!(id, ash_opts(socket)))}
  end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"
end
