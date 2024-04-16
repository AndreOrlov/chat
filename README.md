Описания для сервера чата и клиента в README.md проектов. Сервер использует Genserver Monitor, как в
задании было. Но правильней для Elixir было бы использовать [Registry](https://hexdocs.pm/elixir/1.15.6/Registry.html).

В console_chat используется интерактивная консоль Elixir и в ней проскакивает служебная информация. Если хочется видеть ответы без мусора, то лучше использовать [wscat](https://github.com/websockets/wscat).

Адрес websocket чата - `ws://localhost:4000/ws`

Его можно узнать по адресу - `http://localhost:4000`
