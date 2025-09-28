defmodule FileShareWeb.RoomLive do
  use FileShareWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:media, accept: ~w(.jpg .jpeg .mp4))}
  end

  def handle_event("validate", _unsigned_params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload-file", _unsigned_params, socket) do
    new_entry =
      consume_uploaded_entries(
        socket,
        :media,
        fn %{path: path}, _entry ->
          dest =
            Path.join([:code.priv_dir(:file_share), "static", "uploads", Path.basename(path)])

          File.cp!(path, dest)
          {:ok, ~p"/uploads/{Path.basename(dest)}"}
        end
      )

    {:noreply,
     socket
     |> update(:uploaded_files, &(&1 ++ new_entry))}
  end
end
