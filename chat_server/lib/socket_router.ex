defmodule ChatServer.SocketRouter do
  @moduledoc false

  alias ChatServer.State

  require Logger

  @behaviour :cowboy_websocket

  @impl true
  def init(req, _opts) do
    {
      :cowboy_websocket,
      req,
      %{},
      %{
        idle_timeout: 60_000,
        max_frame_size: 1_000,
      }
    }
  end

  @impl true
  def websocket_init(state \\ %{}) do
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, "@ping"}, state) do
    {:reply, {:text, "pong"}, state}
  end
  def websocket_handle({:text, "@add" <> credentials}, %{username: _} = state) do
    msg =
      with {login, password} <- credentials_parse(credentials),
          {:ok, %{username: _} = _user} <- State.add_user(login, password) do
          "added"
      else
        _ ->
          Logger.warning("#{__MODULE__}: user added error: 'create_error'")
          "create_error"
      end

    {:reply, {:text, msg}, state}
  end
  def websocket_handle({:text, "@add" <> _}, state) do
    Logger.warning("#{__MODULE__}: user added error: 'create_error'")
    {:reply, {:text, "auth_error"}, state}
  end
  def websocket_handle({:text, "@login" <> _}, %{username: _} = state) do
    Logger.warning("#{__MODULE__}: is logined connection error: 'always_connection'")
    {:reply, {:text, "always_connection"}, state}
  end
  def websocket_handle({:text, "@login" <> credentials}, state) do
    {msg, state} =
      with {login, password} <- credentials_parse(credentials),
          {:ok, %{username: username} = _user} <- State.login_user(login, password, self()) do
        {"logined", Map.put(state, :username, username)}
      else
        {:error, :always_connection} = error ->
          Logger.warning("#{__MODULE__}: login error: '#{inspect(error)}'")
          {"always_connection", state}

        error ->
          Logger.warning("#{__MODULE__}: login error: '#{inspect(error)}'")
          {"auth_error", state}
      end

    {:reply, {:text, msg}, state}
  end
  def websocket_handle({:text, "@logout" <> _}, %{username: username} = state) do
    State.logout_user(username)
    {:reply, {:text, "logouted"}, Map.delete(state, :username)}
  end
  def websocket_handle({:text, msg}, %{username: username} = state) do
    unless String.trim(msg) == "", do: State.broadcast(msg, username)
    {:ok, state}
  end
  def websocket_handle({:text, _msg}, state) do
    {:ok, state}
  end

  @impl true
  def websocket_info(msg, state) do
    {:reply, {:text, msg}, state}
  end

  @impl true
  def terminate(_reason, _req, _state), do: :ok

  # private

  defp credentials_parse(""), do: :error
  defp credentials_parse(text) when is_binary(text) do
    text
    |> String.split(" ", trim: true)
    |> case do
      [login, password] -> {String.trim(login), String.trim(password)}
      _ -> :error
    end
  end
end
