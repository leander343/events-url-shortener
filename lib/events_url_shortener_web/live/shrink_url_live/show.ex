defmodule EventsUrlShortenerWeb.ShrinkUrlLive.Show do
  use EventsUrlShortenerWeb, :live_view

  alias EventsUrlShortener.ShrinkUrls

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => key}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shrink_url, ShrinkUrls.get_shrink_url_by_key(key))}
  end

  defp page_title(:show), do: "Show Shrink url"
  defp page_title(:edit), do: "Edit Shrink url"
end
