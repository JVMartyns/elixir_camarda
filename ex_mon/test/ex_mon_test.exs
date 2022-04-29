defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Player

  @player Player.build("Vitor", :chute, :soco, :cura)

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Vitor"
      }

      assert expected_response == ExMon.create_player("Vitor", :chute, :soco, :cura)
    end
  end

  describe "start_game/1" do
    test "when te game is started, returns a message" do
      message =
        capture_io(fn ->
          assert ExMon.start_game(@player) == :ok
        end)

      assert message =~ "The game is started!"
      assert message =~ "status: :started"
    end
  end

  describe "make_move/1" do
    setup do
      capture_io(fn ->
        ExMon.start_game(@player)

        if ExMon.Game.info().turn == :computer do
          ExMon.Game.update(ExMon.Game.info())
        end
      end)

      :ok
    end

    test "when the move is valid, do the move and a computer makes a move" do
      message =
        capture_io(fn ->
          ExMon.make_move(:chute)
        end)

      assert message =~ "The player attacked the computer"
      assert message =~ "It's computer turn"
      assert message =~ "It's player turn"
      assert message =~ "status: :continue"
    end

    test "when the move is invalid returns a error message" do
      message =
        capture_io(fn ->
          ExMon.make_move(:wrong)
        end)

      assert message =~ "Invalid move: wrong."
    end
  end
end
