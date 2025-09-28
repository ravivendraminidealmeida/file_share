defmodule FileShareWeb.RoomHubLive do
  use FileShareWeb, :live_view

  alias FileShare.MediaRoom
  alias FileShare.MediaRoom.Room

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: to_form(FileShare.MediaRoom.change_room(%FileShare.MediaRoom.Room{})))
      |> assign(:rooms, MediaRoom.list_rooms())

    {:ok, socket}
  end

  def handle_event("validate", %{"room" => params}, socket) do
    form =
      %Room{}
      |> MediaRoom.change_room(params)
      |> to_form(action: :validate)

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("create", %{"room" => room_params}, socket) do
    creation_result = MediaRoom.create_room(room_params)

    IO.inspect(creation_result)

    case creation_result do
      {:ok, room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room #{room.id} was created!")
         |> assign(:rooms, MediaRoom.list_rooms())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
