defmodule EventsUrlShortener.Metrics do
  @moduledoc """
  The Metrics context.
  """

  import Ecto.Query, warn: false
  alias EventsUrlShortener.Repo

  alias EventsUrlShortener.Metrics.Metric

  @doc """
  Returns the list of metrics.

  ## Examples

      iex> list_metrics()
      [%Metric{}, ...]

  """
  def list_metrics do
    Repo.all(Metric)
  end

  @doc """
  Gets a single metric.

  Raises `Ecto.NoResultsError` if the Metric does not exist.

  ## Examples

      iex> get_metric!(123)
      %Metric{}

      iex> get_metric!(456)
      ** (Ecto.NoResultsError)

  """
  def get_metric!(id), do: Repo.get!(Metric, id)

  @doc """
  Returns aggregated count of all Browser agents

  ## Examples

      iex> get_metric_aggregate_browser()
      [%{category,total}]

  """

  def get_metric_aggregate_browser!() do
    query =
      from p in "metrics",
        group_by: [p.browser_agent],
        select: %{
          category: p.browser_agent,
          total: count(p.browser_agent)
        }

    Repo.all(query)
  end

  @doc """
  Returns aggregated count of all Locations

  ## Examples

      iex> get_metric_aggregate_location()
      [%{category,total}]

  """

  def get_metric_aggregate_location!() do
    query =
      from p in "metrics",
        group_by: [p.location],
        select: %{
          category: p.location,
          total: count(p.location)
        }

    Repo.all(query)
  end

  @doc """
  Returns aggregated count of OS

  ## Examples

      iex> get_metric_aggregate_os()
      [%{category,total}]

  """

  def get_metric_aggregate_os!() do
    query =
      from p in "metrics",
        group_by: [p.operating_system],
        select: %{
          category: p.operating_system,
          total: count(p.operating_system)
        }

    Repo.all(query)
  end

  @doc """
  Creates a metric.

  ## Examples

      iex> create_metric(%{field: value})
      {:ok, %Metric{}}

      iex> create_metric(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_metric(attrs \\ %{}) do
    %Metric{}
    |> Metric.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a metric.

  ## Examples

      iex> update_metric(metric, %{field: new_value})
      {:ok, %Metric{}}

      iex> update_metric(metric, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_metric(%Metric{} = metric, attrs) do
    metric
    |> Metric.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a metric.

  ## Examples

      iex> delete_metric(metric)
      {:ok, %Metric{}}

      iex> delete_metric(metric)
      {:error, %Ecto.Changeset{}}

  """
  def delete_metric(%Metric{} = metric) do
    Repo.delete(metric)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking metric changes.

  ## Examples

      iex> change_metric(metric)
      %Ecto.Changeset{data: %Metric{}}

  """
  def change_metric(%Metric{} = metric, attrs \\ %{}) do
    Metric.changeset(metric, attrs)
  end
end
