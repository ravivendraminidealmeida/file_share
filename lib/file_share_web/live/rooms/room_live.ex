defmodule FileShareWeb.RoomLive do
  use FileShareWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:media, accept: ~w(.jpg .jpeg .mp4))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="grid grid-cols-4">
        <div class="flex flex-col p-4 gap-3 justify-between rounded-box shadow-md">
          <div class="">
            <%!-- Shared Media --%>
            <div>
              <p class="text-2xl text-primary">Shared Media</p>

              <section class="py-2">
                <%!-- <%= if length(@uploaded_files) > 0 do %>
                <% else %>
                  <p class="opacity-75"></p>
                <% end %> --%>
                <ul class="list bg-base-100">
                  <li class="py-4 px-2 pb-2 text-xs opacity-60 tracking-wide">
                    <%= if length(@uploads.media.entries) > 0 do %>
                      <p class="text-lg">Mídias disponíveis</p>
                    <% else %>
                      <p class="text-lg">Unfortunately, there are no files available. &#128546;</p>
                    <% end %>
                  </li>

                  <li :for={entry <- @uploads.media.entries} class="list-row">
                    <div class="text-4xl font-thin opacity-30 tabular-nums">01</div>

                    <div>
                      <img
                        class="size-10 rounded-box"
                        src="https://img.daisyui.com/images/profile/demo/1@94.webp"
                      />
                    </div>

                    <div class="list-col-grow">
                      <div>{entry.client_name}</div>

                      <div class="text-xs uppercase font-semibold opacity-60">Remaining Reason</div>
                    </div>

                    <button class="btn btn-square btn-ghost">
                      <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <g
                          stroke-linejoin="round"
                          stroke-linecap="round"
                          stroke-width="2"
                          fill="none"
                          stroke="currentColor"
                        >
                          <path d="M6 3L20 12 6 21 6 3z"></path>
                        </g>
                      </svg>
                    </button>
                  </li>
                </ul>
              </section>
            </div>
             <%!-- Media Upload --%>
            <div class="mt-2">
              <p class="text-xl text-primary">My Uploads</p>

              <section class="py-2">
                <form
                  id="upload-form"
                  phx-submit="upload-file"
                  phx-change="validate"
                  class="flex flex-col gap-3"
                >
                  <.live_file_input upload={@uploads.media} class="file-input" />
                  <.button type="submit">Upload!</.button>
                </form>
              </section>
            </div>
          </div>
        </div>

        <div class="colspan-3"></div>
      </div>
    </Layouts.app>
    """
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
