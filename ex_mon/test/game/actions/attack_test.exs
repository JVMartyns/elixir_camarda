defmodule ExMon.Game.Actions.AttackTest do
  use ExUnit.Case

  alias ExMon.Player
  alias ExMon.Game.Actions.Attack

  import ExUnit.CaptureIO

  @player Player.build("Vitor", :chute, :soco, :cura)
  @computer Player.build("Robotinik", :chute, :soco, :cura)

  describe "attack_opponent/2" do
    test "when the opponent is the computer" do
      ExMon.Game.start(@computer, @player)

      message =
        capture_io(fn ->
          Attack.attack_opponent(:computer, :move_avg)
        end)

      assert message =~ "The player attacked the computer"
    end

    test "when the opponent is the player" do
      ExMon.Game.start(@computer, @player)

      message =
        capture_io(fn ->
          Attack.attack_opponent(:player, :move_avg)
        end)

      assert message =~ "The computer attacked the player"
    end
  end
end
