defmodule TTT.OutcomeTest do
  use ExUnit.Case
  alias TTT.Outcome

  describe "Test the Outcome functions" do
    setup do [
      board: [0,0,0,0,0,0,0,0,0],
      one_move: [1,0,0,0,0,0,0,0,0],
      x_line: [1,1,1],
      o_line: [-1,-1,-1],
      no_win: [1, -1, 1],
      h_win: [1,1,1,0,0,0,0,-1,-1],
      v_win: [1,0,0,1,0,0,1,-1,-1],
      d_win: [1,0,0,0,1,-1,-1,0,1],
      four_moves: [1,1,-1,-1,0,0,0,0,0],
      five_moves: [1,1,-1,-1,1,0,0,0,0],
      draw: [1,-1,1,1,-1,1,-1,1,-1]
    ]
    end

    test "three_in_a_row? function returns true when with side wins", fixture do
      assert Outcome.three_in_a_row?(fixture.x_line) == true
      assert Outcome.three_in_a_row?(fixture.o_line) == true
    end

    test "three_in_a_row? function returns false when no on has one", fixture do
      assert Outcome.three_in_a_row?(fixture.no_win) == false
    end

    test "horizontal_win? returns true if there is otherwise false", fixture do
      assert Outcome.horizontal_win?(fixture.h_win) == true
      assert Outcome.horizontal_win?(fixture.board) == false
    end

    test "vertical_win? returns true if there is otherwise false", fixture do
      assert Outcome.vertical_win?(fixture.v_win) == true
      assert Outcome.vertical_win?(fixture.board) == false
    end

    test "diagonal_win? returns true if there is otherwise false", fixture do
      assert Outcome.diagonal_win?(fixture.d_win) == true
      assert Outcome.diagonal_win?(fixture.board) == false
    end

    test "num_turns_taken returns the number of turns that have be played", fixture do
      assert Outcome.num_turns_taken(fixture.board) == 0
      assert Outcome.num_turns_taken(fixture.five_moves) == 5
    end

    test "poss? returns true is 5 or more moves have been played", fixture do
      assert Outcome.poss?(fixture.four_moves) == false
      assert Outcome.poss?(fixture.five_moves) == true
    end

    test "winner? returns true if someone has won, otherwise false", fixture do
      assert Outcome.winner?(fixture.h_win) == true
      assert Outcome.winner?(fixture.v_win) == true
      assert Outcome.winner?(fixture.d_win) == true
      assert Outcome.winner?(fixture.board) == false
    end

    test "outcome returns false when less than 5 moves have been played", fixture do
      assert Outcome.check_outcome(fixture.four_moves) == false
    end

    test "outcome returns :win when there is a win", fixture do
      assert Outcome.check_outcome(fixture.h_win) == :win
    end

    test "outcome returns :draw when theres a draw", fixture do
      assert Outcome.check_outcome(fixture.draw) == :draw
    end

    test "outcome returns false when more than 5 moves have been played but there is no win or draw",
      fixture do
        assert Outcome.check_outcome(fixture.five_moves) == :false
      end
  end
end
