defmodule EventsUrlShortener.ShrinkUrls.ShrinkUrl do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Schema for Shrink URL
  """
  schema "shrink_url" do
    field :hit_count, :integer, default: 0
    field :key, :string
    field :url, EctoFields.URL

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shrink_url, attrs) do
    shrink_url
    |> cast(attrs, [:key, :url, :hit_count])
    |> validate_required([:url])
  end
end
