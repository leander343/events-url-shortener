defmodule EventsUrlShortener.MetricsServer do
  @moduledoc """
  This is GenServer module to handle redirection calls and upload
  metrics
  """
  use GenServer

  alias EventsUrlShortener.Metrics
  alias EventsUrlShortener.ShrinkUrls

  # Subscribe to PubSub call for Redirection
  @impl true
  def init(_) do
    {:ok, {Phoenix.PubSub.subscribe(EventsUrlShortener.PubSub, "Redirected")}}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %Plug.Conn{}, name: __MODULE__)
  end

  # Handle Incoming PubSub broadcast
  @impl true
  def handle_info(%Plug.Conn{} = message, state) do
    # Increment Hit counter
    ShrinkUrls.increment_hit_count(List.first(message.path_info))

    # Obtain user agent value to determine os and browser type
    ua =
      message
      |> Plug.Conn.get_req_header("user-agent")
      |> List.first()
      |> UAParser.parse()

    attrs = %{
      browser_agent: ua.family,
      operating_system: ua.os.family
    }

    # Obtain location of User through IP lookup

    location =
      elem(
        GeoIP.lookup(
          Enum.at(
            message
            |> Plug.Conn.get_req_header("fly-client-ip"),
            0
          )
        ),
        1
      )

    # Find region using country code
    region = Countries.filter_by(:alpha2, location.country)

    Metrics.create_metric(Map.put(attrs, :location, List.first(region).continent))

    Phoenix.PubSub.broadcast(
      EventsUrlShortener.PubSub,
      "update",
      {:pubsub, "Updated"}
    )

    {:noreply, state}
  end
end
