defmodule ExMon.PlayerTest do
  use ExUnit.Case

  describe "build/4" do
    test "create a player" do
      expected_response = %ExMon.Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Vitor"
      }

      assert expected_response == ExMon.Player.build("Vitor", :chute, :soco, :cura)
    end
  end
end
