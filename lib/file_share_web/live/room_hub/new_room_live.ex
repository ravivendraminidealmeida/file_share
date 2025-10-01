defmodule FileShareWeb.NewRoomLive do
  use FileShareWeb, :live_view

  alias FileShare.MediaRoom
  alias FileShare.MediaRoom.Room

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: to_form(MediaRoom.change_room(%Room{})))}
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

    case creation_result do
      {:ok, room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room #{room.id} was created!")
         |> push_navigate(to: ~p"/")
         |> assign(:rooms, MediaRoom.list_rooms())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
