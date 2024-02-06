defmodule EventsUrlShortener.MetricsTest do
  use EventsUrlShortener.DataCase

  alias EventsUrlShortener.Metrics

  describe "metrics" do
    alias EventsUrlShortener.Metrics.Metric

    import EventsUrlShortener.MetricsFixtures

    @invalid_attrs %{browser_agent: nil, location: nil, operating_system: nil}

    test "list_metrics/0 returns all metrics" do
      metric = metric_fixture()
      assert Metrics.list_metrics() == [metric]
    end

    test "get_metric!/1 returns the metric with given id" do
      metric = metric_fixture()
      assert Metrics.get_metric!(metric.id) == metric
    end

    test "create_metric/1 with valid data creates a metric" do
      valid_attrs = %{
        browser_agent: "some browser_agent",
        location: "some location",
        operating_system: "some operating_system"
      }

      assert {:ok, %Metric{} = metric} = Metrics.create_metric(valid_attrs)
      assert metric.browser_agent == "some browser_agent"
      assert metric.location == "some location"
      assert metric.operating_system == "some operating_system"
    end

    test "create_metric/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metrics.create_metric(@invalid_attrs)
    end

    test "update_metric/2 with valid data updates the metric" do
      metric = metric_fixture()

      update_attrs = %{
        browser_agent: "some updated browser_agent",
        location: "some updated location",
        operating_system: "some updated operating_system"
      }

      assert {:ok, %Metric{} = metric} = Metrics.update_metric(metric, update_attrs)
      assert metric.browser_agent == "some updated browser_agent"
      assert metric.location == "some updated location"
      assert metric.operating_system == "some updated operating_system"
    end

    test "update_metric/2 with invalid data returns error changeset" do
      metric = metric_fixture()
      assert {:error, %Ecto.Changeset{}} = Metrics.update_metric(metric, @invalid_attrs)
      assert metric == Metrics.get_metric!(metric.id)
    end

    test "delete_metric/1 deletes the metric" do
      metric = metric_fixture()
      assert {:ok, %Metric{}} = Metrics.delete_metric(metric)
      assert_raise Ecto.NoResultsError, fn -> Metrics.get_metric!(metric.id) end
    end

    test "change_metric/1 returns a metric changeset" do
      metric = metric_fixture()
      assert %Ecto.Changeset{} = Metrics.change_metric(metric)
    end
  end
end
