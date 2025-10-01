defmodule FileShare.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :title, :string, null: false
      add :type, :string, null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    alter table(:rooms) do
      remove :media
    end
  end
end
