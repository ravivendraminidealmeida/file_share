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

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.form for={@form} phx-change="validate" phx-submit="create" class="grid place-items-center">
        <.input type="text" label="Room Name" field={@form[:name]} />
        <.button type="submit" phx-disable-with="Creating...">Create</.button>
      </.form>

      <div>
        <div>
        </div>
      </div>

      <.list>
        <:item :for={room <- @rooms} title="Name">{room.name}</:item>
      </.list>
    </Layouts.app>
    """
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
