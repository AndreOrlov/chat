# ChatServer

### Предустановленные пользователи (логин, пароль):

 - user1, pass1
 - user2, pass2
 - user3, pass3

### Описание команд

- `@ping`, ответ `pong`, доступна для авторизованных и не авторизованных пользователей
- `@login`, ответ `logined`, для авторизованного пользователя ответ `always_connection`. Для       авторизации под другим пользователем нужно разлогиниться. При неверных логине и/или пароле ответ `auth_error`.
- `@logout`, ответ `logouted`для авторизованных пользователей. Для неавторизованных пользователей ответа нет.
- `@added <new_login> <pass>` (добавление нового пользователя), ответ `added` или `create_error` для авторизованных пользователей. Ответ `auth_error` для неавторизованных пользователей. При перезапуске сервера, новые пользователи исчезнут.
- `любой текст`. Если неавторизованных пользователь, ответа нет. Ааторизованный пользователь - рассылка текста всем авторизованным пользователям, кроме самого себя. Формат рассылки `login: <text>`. Пустые сообщения, сообщения состоящии из служебных символов и пробелов не отправляются.

Ограничение длины сообщения - 1000 байт.
Таймаут бездействия соединения - 60 секунд.

## Установка

Операционная система Ubunta или MacOs.

Приложение проверялось на Elixir v.1.15.6 и Erlang/OTP 26.

В папке проекта выполнить:

- `mix deps.get`
- `mix compile`

Запуск сервера `iex -S mix`

По url `http://localhost:4000` выдаст подсказку url своего websocket

Url websocket `ws://localhost:4000/ws`

Выход/остановить сервер - Ctrl+C два раза в консоли сервера.