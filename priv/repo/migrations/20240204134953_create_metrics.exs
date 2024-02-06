defmodule EventsUrlShortener.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  def change do
    create table(:metrics) do
      add :location, :string
      add :browser_agent, :string
      add :operating_system, :string

      timestamps(type: :utc_datetime)
    end
  end
end
