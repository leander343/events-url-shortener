defmodule EventsUrlShortenerWeb.MetricsLive do
  require Logger
  use EventsUrlShortenerWeb, :live_view
  alias EventsUrlShortener.Metrics

  @topic "update"

  # Retrieve counts for different metrics and creaate a Bar chart SVG

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(EventsUrlShortener.PubSub, @topic)
    {:ok, assign(socket, :page_title, "Metrics")}
  end

  # Handle incoming PubSub call from gen server
  @impl true
  def handle_info({:pubsub, _message}, socket) do
    {:noreply, apply_action(socket, :index, %{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> aggregate_metrics()
    |> assign_dataset()
    |> assign_chart_svg()
  end

  defp aggregate_metrics(socket) do
    socket
    |> assign(:aggregate_browser_agents, Metrics.get_metric_aggregate_browser!())
    |> assign(:aggregate_locations, Metrics.get_metric_aggregate_location!())
    |> assign(:aggregate_os, Metrics.get_metric_aggregate_os!())
  end

  defp assign_dataset(
         %{
           assigns: %{
             aggregate_browser_agents: aggregate_browser_agents,
             aggregate_locations: aggregate_locations,
             aggregate_os: aggregate_os
           }
         } = socket
       ) do
    browser_data = Enum.map(aggregate_browser_agents, &[&1.category, &1.total])
    locations_data = Enum.map(aggregate_locations, &[&1.category, &1.total])
    os_data = Enum.map(aggregate_os, &[&1.category, &1.total])

    socket
    |> assign(:browser_dataset, Contex.Dataset.new(browser_data, ["Channel", "Count"]))
    |> assign(:location_dataset, Contex.Dataset.new(locations_data, ["Channel", "Count"]))
    |> assign(:os_dataset, Contex.Dataset.new(os_data, ["Channel", "Count"]))
  end

  defp assign_chart_svg(
         %{
           assigns: %{
             browser_dataset: browser_dataset,
             location_dataset: location_dataset,
             os_dataset: os_dataset
           }
         } = socket
       ) do
    opts = [
      mapping: %{category_col: "Channel", value_col: "Count"},
      colour_palette: ["16a34a", "c13584", "499be4", "FF0000", "00f2ea"],
      legend_setting: :legend_right,
      data_labels: true
    ]

    socket
    |> assign(
      :browser_chart_svg,
      Contex.Plot.new(browser_dataset, Contex.PieChart, 600, 400, opts)
      |> Contex.Plot.to_svg()
    )
    |> assign(
      :location_chart_svg,
      Contex.Plot.new(location_dataset, Contex.PieChart, 600, 400, opts)
      |> Contex.Plot.to_svg()
    )
    |> assign(
      :os_chart_svg,
      Contex.Plot.new(os_dataset, Contex.PieChart, 600, 400, opts)
      |> Contex.Plot.to_svg()
    )
  end
end
