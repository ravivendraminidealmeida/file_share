defmodule FileShare.MediaRoomTest do
  use FileShare.DataCase

  alias FileShare.MediaRoom

  describe "rooms" do
    alias FileShare.MediaRoom.Room

    import FileShare.MediaRoomFixtures

    @invalid_attrs %{name: nil, media: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert MediaRoom.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert MediaRoom.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{name: "some name", media: ["option1", "option2"]}

      assert {:ok, %Room{} = room} = MediaRoom.create_room(valid_attrs)
      assert room.name == "some name"
      assert room.media == ["option1", "option2"]
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MediaRoom.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{name: "some updated name", media: ["option1"]}

      assert {:ok, %Room{} = room} = MediaRoom.update_room(room, update_attrs)
      assert room.name == "some updated name"
      assert room.media == ["option1"]
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = MediaRoom.update_room(room, @invalid_attrs)
      assert room == MediaRoom.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = MediaRoom.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> MediaRoom.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = MediaRoom.change_room(room)
    end
  end
end
