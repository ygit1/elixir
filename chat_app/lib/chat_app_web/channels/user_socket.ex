# lib/chat_app_web/channels/user_socket.ex
defmodule ChatAppWeb.UserSocket do
  use Phoenix.Socket

  # チャンネルの定義
  channel "room:*", ChatAppWeb.RoomChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
