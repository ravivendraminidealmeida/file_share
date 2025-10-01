defmodule FileShareWeb.RoomLive do
  use FileShareWeb, :live_view

  alias FileShare.MediaRoom
  alias FileShare.MediaRoom.{Media, Room}
  alias FileShare.Repo

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  defp determine_media_icon("video" <> _), do: "hero-video-camera"
  defp determine_media_icon("image" <> _), do: "hero-photo"
  defp determine_media_icon("audio" <> _), do: "hero-musical-note"

  def mount(params, _session, socket) do
    media_room =
      MediaRoom.get_room!(params["id"])
      |> Repo.preload(:media)

    {:ok,
     socket
     |> assign(:room, media_room)
     |> allow_upload(:media, accept: ~w(.jpg .jpeg .png .mp4 .wav .mp3 .mpeg), max_entries: 3)}
  end

  def handle_event("validate_upload", _unsigned_params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload_file", _unsigned_params, socket) do
    _uploaded_files =
      consume_uploaded_entries(socket, :media, fn meta, entry ->
        dest_dir =
          Path.join(
            "priv/static/uploads/rooms/",
            "#{socket.assigns.room.id}"
          )

        dest_path = Path.join(dest_dir, entry.client_name)

        File.mkdir_p!(dest_dir)
        File.cp!(meta.path, dest_path)

        MediaRoom.create_media(%{
          title: Path.basename(entry.client_name),
          type: entry.client_type,
          room_id: socket.assigns.room.id
        })

        {:ok, ~p"/uploads/#{Path.basename(entry.client_name)}"}
      end)

    updated_room =
      MediaRoom.get_room!(socket.assigns.room.id)
      |> Repo.preload(:media)

    {:noreply,
     socket
     |> assign(:room, updated_room)
     |> put_flash(:info, "Media uploaded successfully!")}
  end
end
