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
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:step, 1)}
  end
end

defmodule VachanWeb.CampaignWizard.ContentStep do
  use VachanWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="mt-20">
      <textarea> </textarea>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
