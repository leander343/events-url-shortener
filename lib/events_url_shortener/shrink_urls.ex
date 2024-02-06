defmodule EventsUrlShortener.ShrinkUrls do
  @moduledoc """
  The ShrinkUrls context.
  """

  import Ecto.Query, warn: false
  alias EventsUrlShortener.Repo

  alias EventsUrlShortener.ShrinkUrls.ShrinkUrl

  @doc """
  Returns the url for key provided.

  ## Examples

      iex> get_shrink_url_by_key(key)
      [%ShrinkUrl{}, ...]

  """
  def get_shrink_url_by_key(key), do: Repo.get_by(ShrinkUrl, key: key)

  @doc """
  Returns the list of urls.

  ## Examples

      iex> get_shrink_url()
      [%ShrinkUrl{}, ...]

  """
  def get_shrink_url() do
    Repo.all(ShrinkUrl)
  end

  @doc """
  Creates a url with random key.

  ## Examples

      iex> create_shrink_url(%{field: value})
      {:ok, %ShrinkUrl{}}

      iex> create_shrink_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_shrink_url(attrs \\ %{}) do
    attrs = assign_random_key(attrs)

    %ShrinkUrl{}
    |> ShrinkUrl.changeset(attrs)
    |> Repo.insert()
  rescue
    # Retry in case the same key already exists in database
    Ecto.ConstraintError ->
      create_shrink_url(attrs)
  end

  # Generates and assigns a random key when key is blank.
  defp assign_random_key(attrs) do
    if attrs[:key] in [nil, ""] do
      Map.put(attrs, :key, random_string(4))
    else
      attrs
    end
  end

  defp random_string(length) when is_integer(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> String.replace(~r/[-_\=]/, "")
    |> binary_part(0, length)
  end

  @doc """
  Updates a url.

  ## Examples

      iex> update_shrink_url(shrink_url, %{field: new_value})
      {:ok, %ShrinkUrl{}}

      iex> update_shrink_url(shrink_url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_shrink_url(%ShrinkUrl{} = shrink_url, attrs) do
    shrink_url
    |> ShrinkUrl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Increment hit count on URL

  ## Examples

      iex> increment_hit_count(shrink_url)
      {:ok, %ShrinkUrl{}}


  """

  def increment_hit_count(key) do
    shrink_url = get_shrink_url_by_key(key)
    update_shrink_url(shrink_url, %{hit_count: shrink_url.hit_count + 1})
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_shrink_url(shrink_url)
      {:ok, %ShrinkUrl{}}

      iex> delete_shrink_url(shrink_url)
      {:error, %Ecto.Changeset{}}

  """

  def delete_shrink_url(%ShrinkUrl{} = shrink_url) do
    Repo.delete(shrink_url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change_shrink_url(shrink_url)
      %Ecto.Changeset{data: %ShrinkUrl{}}
  """

  def change_shrink_url(%ShrinkUrl{} = shrink_url, attrs \\ %{}) do
    ShrinkUrl.changeset(shrink_url, attrs)
  end
end
