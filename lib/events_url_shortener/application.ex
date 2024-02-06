defmodule EventsUrlShortener.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EventsUrlShortenerWeb.Telemetry,
      EventsUrlShortener.Repo,
      {DNSCluster,
       query: Application.get_env(:events_url_shortener, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EventsUrlShortener.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EventsUrlShortener.Finch},
      # Start a worker by calling: EventsUrlShortener.Worker.start_link(arg)
      # {EventsUrlShortener.Worker, arg},
      # Start to serve requests, typically the last entry
      EventsUrlShortenerWeb.Endpoint,
      # Sat a Gen server to handle redirection PubSub calls
      Supervisor.child_spec(EventsUrlShortener.MetricsServer,
        id: EventsUrlShortener.MetricsServer
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventsUrlShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventsUrlShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
