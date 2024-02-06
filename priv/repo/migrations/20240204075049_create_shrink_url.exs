defmodule EventsUrlShortener.Repo.Migrations.CreateShrinkUrl do
  use Ecto.Migration

  def change do
    create table(:shrink_url) do
      add :key, :string, null: false
      add :url, :text, null: false
      add :hit_count, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:shrink_url, [:key], unique: true)
  end
end
