defmodule ChatServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_server,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ChatServer.Application, []},
    ]
  end

  # private

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},

      # test
      # TODO: rad
      # {:console_chat, path: "../../console_chat", only: :test, runtime: false},
      {:console_chat, path: "../../console_chat", runtime: true},

      # code climate
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false}
    ]
  end
end
