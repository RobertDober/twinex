defmodule TwinexTest do
  use ExUnit.Case
  doctest Twinex

  test "greets the world" do
    assert Twinex.hello() == :world
  end
end
