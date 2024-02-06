defmodule EventsUrlShortener.MetricsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EventsUrlShortener.Metrics` context.
  """

  @doc """
  Generate a metric.
  """
  def metric_fixture(attrs \\ %{}) do
    {:ok, metric} =
      attrs
      |> Enum.into(%{
        browser_agent: "some browser_agent",
        location: "some location",
        operating_system: "some operating_system"
      })
      |> EventsUrlShortener.Metrics.create_metric()

    metric
  end
end
