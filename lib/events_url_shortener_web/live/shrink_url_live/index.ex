defmodule EventsUrlShortenerWeb.ShrinkUrlLive.Index do
  use EventsUrlShortenerWeb, :live_view

  alias EventsUrlShortener.ShrinkUrls
  alias EventsUrlShortener.ShrinkUrls.ShrinkUrl

  @topic "update"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(EventsUrlShortener.PubSub, @topic)
    {:ok, stream(socket, :shrink_url_collection, ShrinkUrls.get_shrink_url())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"key" => key}) do
    socket
    |> assign(:page_title, "Edit Shrink url")
    |> assign(:shrink_url, ShrinkUrls.get_shrink_url_by_key(key))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shrink url")
    |> assign(:shrink_url, %ShrinkUrl{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shrink url")
    |> assign(:shrink_url, nil)
  end

  @impl true
  def handle_info(
        {EventsUrlShortenerWeb.ShrinkUrlLive.FormComponent, {:saved, shrink_url}},
        socket
      ) do
    {:noreply, stream_insert(socket, :shrink_url_collection, shrink_url)}
  end

  # Handle pub sub call from Gen Server and update metrics
  @impl true
  def handle_info({:pubsub, _message}, socket) do
    send_update(EventsUrlShortenerWeb.ShrinkUrlLive.MetricsComponent, id: "metrics")
    {:noreply, stream(socket, :shrink_url_collection, ShrinkUrls.get_shrink_url())}
  end

  @impl true
  def handle_event("delete", %{"key" => key}, socket) do
    shrink_url = ShrinkUrls.get_shrink_url_by_key(key)
    {:ok, _} = ShrinkUrls.delete_shrink_url(shrink_url)

    {:noreply, stream_delete(socket, :shrink_url_collection, shrink_url)}
  end
end
