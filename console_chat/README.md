# ConsoleChat

## Описание

В консоли Elixir, для соединения с websocket выполнить

```elixir
ConsoleChat.start_link()
```

Произойдет соединение с websocket по адресу `ws://localhost:4000/ws`

Для отправки текста и комманд выполнять

```elixir
ConsoleChat.echo("текст или команда")
```

## Установка

Операционная система Ubunta или MacOs.

Приложение проверялось на Elixir v.1.15.6 и Erlang/OTP 26.

В папке проекта выполнить:

- `mix deps.get`
- `mix compile`

Запустить интерактивную консоль Elixir `iex -S mix`
