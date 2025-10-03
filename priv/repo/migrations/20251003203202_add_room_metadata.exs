defmodule FileShare.Repo.Migrations.AddRoomMetadata do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :metadata, :map
    end
  end
end
