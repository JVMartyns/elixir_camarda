defmodule ExMon.GameTest do
  use ExUnit.Case, async: true

  alias ExMon.{Game, Player}

  @player Player.build("Vitor", :chute, :soco, :cura)
  @computer Player.build("Robotinik", :chute, :soco, :cura)

  @expected_responde %{
    computer: %Player{
      life: 100,
      moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
      name: "Robotinik"
    },
    player: %Player{
      life: 100,
      moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
      name: "Vitor"
    },
    status: :started,
    turn: :player
  }

  describe "start/2" do
    test "starts the game state" do
      assert({:ok, _pid} = Game.start(@computer, @player))
    end
  end

  describe "info/0" do
    test "return the cuttent game state" do
      Game.start(@computer, @player)

      assert @expected_responde == %{Game.info() | turn: :player}
    end
  end

  describe "update/1" do
    test "return the curent game state" do
      Game.start(@computer, @player)

      assert %{
               player: %{life: 100},
               computer: %{life: 100},
               status: :started
             } = Game.info()

      new_state = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Vitor"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      expected_responde = %{new_state | turn: :computer, status: :continue}

      assert expected_responde == Game.info()
    end
  end

  describe "player/0" do
    test "return a current player" do
      Game.start(@computer, @player)

      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Vitor"
      }

      assert expected_response == Game.player()
    end
  end

  describe "turn/0" do
    test "returns whose turn it is" do
      Game.start(@computer, @player)

      assert Game.turn() in [:computer, :player]
    end
  end

  describe "fetch_player/1" do
    test "returns whose turn it is" do
      Game.start(@computer, @player)

      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Vitor"
      }

      assert expected_response == Game.fetch_player(:player)
    end
  end

  describe "update_game_status/1" do
    test "when the life is 0" do
      state = %{
        computer: %Player{
          life: 0,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        player: %Player{
          life: 0,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Vitor"
        },
        status: :started,
        turn: :player
      }

      expected_responde = %{state | status: :game_over}

      assert expected_responde == Game.update_game_status(state)
    end

    test "when life is greater than 0" do
      expected_responde = %{@expected_responde | turn: :computer, status: :continue}

      assert expected_responde == Game.update_game_status(@expected_responde)
    end
  end

  describe "update_turn" do
    test "when the player turn" do
      state = %{@expected_responde | turn: :computer}

      assert %{turn: :player} = Game.update_turn(state)
    end

    test "when the computer turn" do
      assert %{turn: :computer} = Game.update_turn(@expected_responde)
    end
  end
end
