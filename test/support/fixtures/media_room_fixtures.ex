defmodule FileShare.MediaRoomFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FileShare.MediaRoom` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        media: ["option1", "option2"],
        name: "some name"
      })
      |> FileShare.MediaRoom.create_room()

    room
  end
end
