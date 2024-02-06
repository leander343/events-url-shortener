defmodule EventsUrlShortener.Metrics.Metric do
  use Ecto.Schema
  import Ecto.Changeset

@moduledoc """
Schema for Metrics
"""
  schema "metrics" do
    field :browser_agent, :string
    field :location, :string
    field :operating_system, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:location, :browser_agent, :operating_system])
    |> validate_required([:location, :browser_agent, :operating_system])
  end
end
