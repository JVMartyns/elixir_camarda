defmodule ExMon.Game.StatusTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "print_round_message/1" do
    test "when the game status is started" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_round_message(%{status: :started})
        end)

      assert message =~ "The game is started!"
    end

    test "when the game status is continue" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_round_message(%{status: :continue, turn: :player})
        end)

      assert message =~ "It's player turn!"
    end

    test "when the game status is game_over" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_round_message(%{status: :game_over, turn: :player})
        end)

      assert message =~ "The game is over!"
    end
  end

  describe "print_wrong_move_message/1" do
    test "print error message" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_wrong_move_message(:wrong)
        end)

      assert message =~ "Invalid move: wrong"
    end
  end

  describe "print_move_message/3" do
    test "when the player attacks the computer" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_move_message(:computer, :attack, 25)
        end)

      assert message =~ "The player attacked the computer dealing 25 damage"
    end

    test "when the computer attacks the player" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_move_message(:player, :attack, 25)
        end)

      assert message =~ "The computer attacked the player dealing 25 damage"
    end

    test "when the player heal itself" do
      message =
        capture_io(fn ->
          ExMon.Game.Status.print_move_message(:player, :heal, 25)
        end)

      assert message =~ "The player healled itself to 25 life points"
    end
  end
end
