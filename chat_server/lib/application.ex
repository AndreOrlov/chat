defmodule ChatServer.Application do
  @moduledoc false

  alias ChatServer.State

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {
          Plug.Cowboy,
          scheme: :http,
          plug: ChatServer.Router,
          options: [
            port: 4000,
            dispatch: dispatcher(),
          ],
        },
        {State, state()},
      ]
    opts = [strategy: :one_for_all, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  # private

  defp dispatcher do
    [
      {
        :_,
        [
          {"/ws", ChatServer.SocketRouter, []},
          {:_, Plug.Cowboy.Handler, {ChatServer.Router, []}},
        ]
      }
    ]
  end

  defp state do
    users =
      [
        %{username: "user1", password: "pass1"},
        %{username: "user2", password: "pass2"},
        %{username: "user3", password: "pass3"},
      ]
      |> Enum.reduce(%{}, & Map.put(&2, &1.username, &1))
    %{users: users}
  end
end
