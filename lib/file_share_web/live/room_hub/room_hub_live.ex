defmodule FileShareWeb.RoomHubLive do
  use FileShareWeb, :live_view

  alias FileShare.MediaRoom

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:rooms, MediaRoom.list_rooms())

    {:ok, socket}
  end
end
