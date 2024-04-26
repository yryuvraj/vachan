defmodule VachanWeb.VerifyEmailLive do
  use VachanWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center mt-12">
      <h1>Verify Email</h1>
      You must verify your email.
    </div>
    """
  end
end
