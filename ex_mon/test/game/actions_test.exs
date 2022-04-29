defmodule ExMon.Game.ActionsTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions

  import ExUnit.CaptureIO

  @player Player.build("Vitor", :chute, :soco, :cura)
  @computer Player.build("Robotinik", :chute, :soco, :cura)

  describe "attack/1" do
    test "when the player turn" do
      Game.start(@computer, @player)

      if Game.info().turn == :computer do
        Game.update(Game.info())
      end

      message =
        capture_io(fn ->
          Actions.attack(:move_avg)
        end)

      assert message =~ "The player attacked the computer"
    end

    test "when the computer turn" do
      Game.start(@computer, @player)

      if Game.info().turn == :player do
        Game.update(Game.info())
      end

      message =
        capture_io(fn ->
          Actions.attack(:move_avg)
        end)

      assert message =~ "The computer attacked the player"
    end
  end

  describe "heal/0" do
    test "when the player turn" do
      Game.start(@computer, @player)

      if Game.info().turn == :computer do
        Game.update(Game.info())
      end

      message =
        capture_io(fn ->
          Actions.heal()
        end)

      assert message =~ "The player healled itself"
    end

    test "when the computer turn" do
      Game.start(@computer, @player)

      if Game.info().turn == :player do
        Game.update(Game.info())
      end

      message =
        capture_io(fn ->
          Actions.heal()
        end)

      assert message =~ "The computer healled itself"
    end
  end

  describe "fetch_move/1" do
    test "when a valid move" do
      Game.start(@computer, @player)
      assert {:ok, :move_rnd} == Actions.fetch_move(:chute)
    end

    test "when a invalid move" do
      Game.start(@computer, @player)
      assert {:error, :wrong} == Actions.fetch_move(:wrong)
    end
  end
end
