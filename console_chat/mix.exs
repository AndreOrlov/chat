defmodule ConsoleChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :console_chat,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ConsoleChat.Application, []},
    ]
  end

  # private

  defp deps do
    [
      {:websockex, "~> 0.4.3"},

      # code climate
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false}
    ]
  end
end
