defmodule ChatServer.Router do
  @moduledoc false

  use Plug.Router

  plug :match
  plug :dispatch

  match _ do
    send_resp conn, 200, "Web socket - ws://localhost:4000/ws"
  end
end
