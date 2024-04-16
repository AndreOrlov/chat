defmodule ConsoleChat do
  @moduledoc false

  require Logger

  use WebSockex

  def init(state \\ %{}) do
    {:ok, state}
  end

  def start_link(state \\ %{}) do
    WebSockex.start_link("ws://localhost:4000/ws", __MODULE__, state, name: __MODULE__)
  end

  @spec echo(binary) :: :ok | {:error, map}
  def echo(text) do
    WebSockex.send_frame(__MODULE__, {:text, text})
  end

  @impl true
  def handle_connect(_conn, state) do
    Logger.info("Connected")
    {:ok, state}
  end

  @impl true
  def handle_frame({:text, msg}, state) do
    IO.puts msg
    {:ok, state}
  end
  def handle_frame(_frame, state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:send, {:text, msg} = frame}, state) do
    IO.puts msg
    {:reply, frame, state}
  end
  def handle_cast({:send, frame}, state) do
    {:reply, frame, state}
  end

  @impl true
  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect(reason)}")
    IO.puts "Connection close"
    {:ok, state}
  end
  def handle_disconnect(%{reason: {:remote, reason, _}}, state) do
    Logger.info("Remote close with reason: #{inspect(reason)}")
    IO.puts "Connection close"
    {:ok, state}
  end
  def handle_disconnect(disconnect_map, state) do
    Logger.info("Local close: #{inspect(disconnect_map)}")
    IO.puts "Connection close"
    super(disconnect_map, state)
  end
end
