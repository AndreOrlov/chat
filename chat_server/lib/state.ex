defmodule ChatServer.State do
  @moduledoc false

  use GenServer

  @impl true
  def init(state \\ %{}) do
    default = %{users: %{}, logined_users: %{}}
    {:ok, Map.merge(default, state)}
  end

  @spec start_link(any) :: {:ok, pid} | {:error, any} | :ignore
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec add_user(binary | any, binary | any) ::
    {:ok, map()} | {:error, :user_existed} | {:error, :wrong_params}
  def add_user(username, password) when is_binary(username) and is_binary(password) do
    GenServer.call(__MODULE__, {:add_user, username, password})
  end
  def add_user(_, _), do: {:error, :wrong_params}

  @spec login_user(binary | any, binary | any, pid | any) ::
    {:ok, map} | {:error, :auth_error} | {:error, :always_connection}
  def login_user(username, password, pid) when is_binary(username) and is_binary(password) and is_pid(pid) do
    GenServer.call(__MODULE__, {:login_user, username, password, pid})
  end
  def login_user(_, _, _), do: {:error, :auth_error}

  @spec logout_user(any) :: :ok
  def logout_user(username) do
    GenServer.call(__MODULE__, {:logout_user, username})
  end

  @spec broadcast(binary | any, binary | any) :: :ok
  def broadcast(text, username) when is_binary(text) and is_binary(username) do
    GenServer.cast(__MODULE__, {:broadcast, text, username})
    :ok
  end
  def broadcast(_, _), do: :ok

  # server

  @impl true
  def handle_call({:add_user, username, password}, _from, state) do
    %{users: users} = state
    {res, state} =
      if Map.has_key?(users, username) do
        {{:error, :user_existed}, state}
      else
        new_user = %{username: username, password: password}
        users = Map.put(users, username, new_user)
        state = %{state | users: users}
        {{:ok, new_user}, state}
      end

    {:reply, res, state}
  end
  def handle_call({:login_user, username, password, pid}, _from, state) do
    %{users: users, logined_users: logined_users} = state
    {res, state} =
      with %{username: ^username, password: ^password} = user <- Map.get(users, username, :user_not_existed),
           false <- Map.has_key?(logined_users, username) do
        Process.monitor(pid)
        logined_users = Map.put(logined_users, username, pid)
        {{:ok, user}, %{state | logined_users: logined_users}}
      else
        :user_not_existed -> {{:error, :user_not_existed}, state}
        true -> {{:error, :always_connection}, state}
        _ -> {{:error, :wrong_password}, state}
      end

    {:reply, res, state}
  end
  def handle_call({:logout_user, username}, _from, state) do
    {:reply, :ok, logout_user(state, username)}
  end

  @impl true
  def handle_cast({:broadcast, text, username}, state) do
    msg = username <> ": " <> text
    state
    |> Map.get(:logined_users, %{})
    |> Enum.each(fn
      {^username, _pid} -> nil
      {_username, pid} -> send(pid, msg)
      _ -> nil
    end)

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {:noreply, logout_user(state, pid)}
  end
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # private

  defp logout_user(%{logined_users: logined_users} = state, pid) when is_pid(pid) do
    logined_users = logined_users |> Enum.reject(& match?({_username, ^pid}, &1)) |> Enum.into(%{})

    %{state | logined_users: logined_users}
  end
  defp logout_user(%{logined_users: logined_users} = state, username) when is_binary(username) do
    %{state | logined_users: Map.delete(logined_users, username)}
  end
  defp logout_user(state, _), do: state
end
