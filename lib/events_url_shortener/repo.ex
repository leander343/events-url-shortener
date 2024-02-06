defmodule EventsUrlShortener.Repo do
  use Ecto.Repo,
    otp_app: :events_url_shortener,
    adapter: Ecto.Adapters.Postgres
end
