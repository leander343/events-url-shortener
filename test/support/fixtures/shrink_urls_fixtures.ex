defmodule EventsUrlShortener.ShrinkUrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EventsUrlShortener.ShrinkUrls` context.
  """

  @doc """
  Generate a shrink_url.
  """
  def shrink_url_fixture(attrs \\ %{}) do
    {:ok, shrink_url} =
      attrs
      |> Enum.into(%{
        hit_count: 42,
        url: "http://example.com"
      })
      |> EventsUrlShortener.ShrinkUrls.create_shrink_url()

    shrink_url
  end
end
