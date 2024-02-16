defmodule Vachan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VachanWeb.Telemetry,
      Vachan.Repo,
      {DNSCluster, query: Application.get_env(:vachan, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Vachan.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Vachan.Finch},
      # Start a worker by calling: Vachan.Worker.start_link(arg)
      # {Vachan.Worker, arg},
      # Start to serve requests, typically the last entry
      VachanWeb.Endpoint,
      {AshAuthentication.Supervisor, otp_app: :example}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vachan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VachanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
