defmodule VachanWeb.CampaignWizard.CampaignWizardLive do
  use VachanWeb, :live_view

  @doc """
  Multi step wizard for creation of a campaign.
  - step 1: create campaign content |> plain text vs mjml.
  - step 2: select people to send it to |> add people if none exist.
  - step 3: select the credentials to use to do it. |> add if none exist.
  - step 4: schedule / send.
  - step 5: view status updates.

  There shall be separate components for every step of the process.
  """

  def wizard_steps(campaign_id) do
    [
      %{
        live_action: :new,
        module: VachanWeb.CampaignWizard.NewCampaign,
        next: ~p"/wizard/#{campaign_id}/add-content/"
      },
      %{
        live_action: :add_content,
        module: VachanWeb.CampaignWizard.ContentStep,
        next: ~p"/wizard/#{campaign_id}/add-recepients/"
      },
      %{
        live_action: :add_recepients,
        module: VachanWeb.CampaignWizard.AddRecepients,
        next: ~p"/wizard/#{campaign_id}/add-sender-profile/"
      },
      %{
        live_action: :add_gateway,
        module: VachanWeb.CampaignWizard.AddSenderProfile,
        next: ~p"/wizard/#{campaign_id}/review/"
      }
    ]
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:steps, [])}
  end

  @impl true
  def handle_params(%{"id" => campaign_id} = _unsigned_params, _uri, socket) do
    steps = wizard_steps(campaign_id)

    {:noreply,
     socket
     |> assign(:campaign_id, campaign_id)
     |> assign(:steps, steps)}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end
end
