defmodule FileShareWeb.RoomLive do
  use FileShareWeb, :live_view

  alias FileShare.MediaRoom

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def mount(params, _session, socket) do
    media_room = MediaRoom.get_room!(params["id"])

    {:ok,
     socket
     |> assign(:room, media_room)
     |> allow_upload(:media, accept: ~w(.jpg .jpeg .mp4 .wav), max_entries: 3)}
  end

  def handle_event("validate_upload", _unsigned_params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload_file", _unsigned_params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :media, fn %{path: path}, _entry ->
        dest =
          Path.join(Application.app_dir(:file_share, "priv/static/uploads"), Path.basename(path))

        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    dbg(uploaded_files)

    {:noreply, socket}
  end
end
