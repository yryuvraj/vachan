defmodule VachanWeb.CampaignWizard.NewCampaign do
  use VachanWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center h-screen">
      <div>
        <.simple_form></.simple_form>
      </div>
    </div>
    """
  end
end
