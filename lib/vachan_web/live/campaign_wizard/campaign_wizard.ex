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

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:step, 1)}
  end

  @impl true
  def handle_params(%{"id" => campaign_id} = _unsigned_params, _uri, socket) do
    {:noreply, socket |> assign(:campaign_id, campaign_id)}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end
end
