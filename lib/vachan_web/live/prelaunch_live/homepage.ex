defmodule VachanWeb.PrelaunchLive.Homepage do
  use VachanWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {VachanWeb.Layouts, :root}}
  end
end
