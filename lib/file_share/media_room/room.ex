defmodule FileShare.MediaRoom.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias FileShare.MediaRoom.Media

  schema "rooms" do
    field :name, :string
    has_one :selected_media, Media
    has_many :media, Media, preload_order: [desc: :inserted_at]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
