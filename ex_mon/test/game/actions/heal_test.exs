defmodule ExMon.Game.Actions.HealTest do
  use ExUnit.Case

  alias ExMon.Player
  alias ExMon.Game.Actions.Heal

  import ExUnit.CaptureIO

  @player Player.build("Vitor", :chute, :soco, :cura)
  @computer Player.build("Robotinik", :chute, :soco, :cura)

  describe "heal_life/1" do
    test "when the player heals" do
      ExMon.Game.start(@computer, @player)

      message =
        capture_io(fn ->
          Heal.heal_life(:player)
        end)

      assert message =~ "The player healled itself"
    end

    test "when the computer heals" do
      ExMon.Game.start(@computer, @player)

      message =
        capture_io(fn ->
          Heal.heal_life(:computer)
        end)

      assert message =~ "The computer healled itself"
    end
  end
end
