defmodule FileShare.MediaRoom.Media do
  use Ecto.Schema
  import Ecto.Changeset

  schema "media" do
    field :current_time_in_seconds, :integer
    field :media_state, Ecto.Enum, values: [:running, :stopped, :loading]

    field :title, :string
    field :type, :string
    belongs_to :room, FileShare.MediaRoom.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media, attrs) do
    media
    |> cast(attrs, [:title, :type, :room_id])
    |> validate_required([:title, :type, :room_id])
  end
end
