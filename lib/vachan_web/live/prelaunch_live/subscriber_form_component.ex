defmodule VachanWeb.PrelaunchLive.SubscriberFormComponent do
  use VachanWeb, :live_component

  alias Vachan.Prelaunch

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @status == :new do %>
        <.simple_form
          for={@form}
          id="lead-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:email]} type="email" label="Email" />
          <.input
            field={@form[:subscribe_newsletter]}
            type="checkbox"
            label="I want to subscribe to the newsletter."
          />
          <.input
            field={@form[:join_beta_tester]}
            type="checkbox"
            label="I want to join the beta tester program."
          />
          <:actions>
            <.button phx-disable-with="Saving...">Submit</.button>
          </:actions>
        </.simple_form>
      <% else %>
        <p>Thank you for signing up. We will notify you when we launch!</p>
      <% end %>
    </div>
    """
  end

  defp create_form() do
    Prelaunch.Subscriber
    |> AshPhoenix.Form.for_create(:create, api: Prelaunch)
    |> to_form()
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, create_form())}
  end

  @impl true
  def handle_event("validate", %{"form" => subscriber_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, subscriber_params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"form" => subscriber_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, subscriber_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, subscriber} ->
        notify_parent({:saved, subscriber})

        {:noreply,
         socket
         |> put_flash(:info, "We will notify you when we launch!")
         |> assign(:status, :saved)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
