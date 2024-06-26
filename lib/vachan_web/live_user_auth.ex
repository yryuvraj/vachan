defmodule VachanWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in liveviews
  """

  import Phoenix.Component
  use VachanWeb, :verified_routes

  alias Vachan.Profiles

  def on_mount(:live_user_optional, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:live_user_required, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    end
  end

  def on_mount(:live_no_user, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:live_confirmed_user_required, _params, _session, socket) do
    if socket.assigns[:current_user] do
      if socket.assigns[:current_user].confirmed_at != nil do
        {:cont, socket}
      else
        {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/verify-email")}
      end
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    end
  end

  def on_mount(:live_profile_required, _params, _session, socket) do
    if socket.assigns[:current_user] do
      user = socket.assigns[:current_user]

      if user.confirmed_at != nil do
        case Ash.get(Profiles.Profile, socket.assigns[:current_user].id, actor: user) do
          {:ok, _} ->
            {:ok, org} =
              Vachan.Organizations.Organization.get_personal_org_for_user(
                socket.assigns[:current_user].id,
                actor: nil,
                authorize?: false
              )

            {:cont, assign(socket, :current_org, org)}

          {:error, _} ->
            {:halt, Phoenix.LiveView.push_navigate(socket, to: ~p"/profile")}
        end
      else
        {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/verify-email")}
      end
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    end
  end
end
