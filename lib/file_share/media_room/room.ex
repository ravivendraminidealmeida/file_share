defmodule FileShare.MediaRoom.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias FileShare.MediaRoom.Media

  schema "rooms" do
    field :name, :string
    has_many :media, Media, preload_order: [desc: :inserted_at]

    embeds_one :metadata, Metadata do
      field :current_time_in_seconds, :integer
      field :media_state, Ecto.Enum, values: [:running, :stopped, :loading]
    end

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
