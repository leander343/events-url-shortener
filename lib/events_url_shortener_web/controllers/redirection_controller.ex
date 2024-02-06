defmodule EventsUrlShortenerWeb.RedirectionController do
  use EventsUrlShortenerWeb, :controller

  alias Phoenix.PubSub
  alias EventsUrlShortener.ShrinkUrls

  # GET /:key
  def index(conn, %{"key" => key}) do
    # Redirect valid key and broad cast pub sub topic
    # or redirect to home page for an invalid linke
    case ShrinkUrls.get_shrink_url_by_key(key) do
      nil ->
        conn
        |> put_flash(:error, "Invalid short link")
        |> redirect(to: "/")

      shrink_url ->
        PubSub.broadcast(EventsUrlShortener.PubSub, "Redirected", conn)
        redirect(conn, external: shrink_url.url)
    end
  end
end
