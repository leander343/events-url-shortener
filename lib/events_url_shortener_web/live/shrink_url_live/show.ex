defmodule EventsUrlShortenerWeb.ShrinkUrlLive.Show do
  use EventsUrlShortenerWeb, :live_view

  alias EventsUrlShortener.ShrinkUrls

  @topic "update"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(EventsUrlShortener.PubSub, @topic)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => key}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shrink_url, ShrinkUrls.get_shrink_url_by_key(key))
     |> assign(:key, key)}
  end

  @impl true
  def handle_info({:pubsub, _message}, socket) do
    {:noreply,
     socket
     |> assign(:shrink_url, ShrinkUrls.get_shrink_url_by_key(socket.assigns.key))}
  end

  defp page_title(:show), do: "Show Shrink url"
  defp page_title(:edit), do: "Edit Shrink url"
end
