defmodule VachanWeb.CampaignWizard.Review do
  use VachanWeb, :live_component

  @doc """
  The last stage of the wizard, where all the details of the campaign are reviewed before hitting the send button.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      Review
    </div>
    """
  end
end
