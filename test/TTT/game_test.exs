defmodule TTT.GameTest do
  use ExUnit.Case
  alias TTT.Game

  describe "Game works as expected" do
    setup do [
      board: [0,0,0,0,0,0,0,0,0],
      one_move: [1,0,0,0,0,0,0,0,0],
      five_moves: [1,1,-1,-1,1,0,0,0,0],
      eight_moves: [1,-1,1,1,-1,1,-1,1,0]
    ]
    end

    test "Board is created as expected", fixture do
      assert Game.create_board == fixture.board
    end

    test "update_board returns board with players move", fixture do
      assert Game.update_board(fixture.board, 1, 1) == fixture.one_move
    end

    test "get_comp_move picks a random tile that has not been played on yet",
      fixture do
        comp_move = Game.get_comp_move(fixture.five_moves)
        empty_tiles_indexes_at_five_moves = [5,6,7,8]

        assert comp_move in empty_tiles_indexes_at_five_moves
        assert Game.get_comp_move(fixture.eight_moves) == 8
    end
  end
end
