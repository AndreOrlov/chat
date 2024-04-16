defmodule ChatServerTest do
  use ExUnit.Case

  describe "Succesful tests" do
    test "always pass" do
      # IO.inspect("AAAA")

      ConsoleChat.start_link() # |> IO.inspect(label: ANDRE_1)
      ConsoleChat.echo("@ping") # |> IO.inspect(label: ANDRE2)
      # Process.sleep(2_000)
      # assert true
      assert_receive("pong", 1_000)
    end
  end
end
