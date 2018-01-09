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
      comp_win: [-1, -1, -1, 0, 1, 1, 1, 1, 0],
      five_moves: [1,1,-1,-1,1,0,0,0,0],
      draw: [1,-1,1,1,-1,1,-1,1,-1]
    ]
    end

    test "three_in_a_row returns atom of team that has 3 in a row", fixture do
      assert Outcome.three_in_a_row(fixture.x_line) == :player1
      assert Outcome.three_in_a_row(fixture.o_line) == :player2
    end

    test "three_in_a_row returns false when there are not 3 in a row", fixture do
      assert Outcome.three_in_a_row(fixture.no_win) == false
    end

    test "horizontal_win returns atom of team with 3 in a row, otherwise false", fixture do
      assert Outcome.horizontal_win(fixture.h_win) == :player1
      assert Outcome.horizontal_win(fixture.board) == false
    end

    test "vertical_win returns atom of team with 3 in a row, otherwise false", fixture do
      assert Outcome.vertical_win(fixture.v_win) == :player1
      assert Outcome.vertical_win(fixture.board) == false
    end

    test "diagonal_win returns atom of team with 3 in a row, otherwise false", fixture do
      assert Outcome.diagonal_win(fixture.d_win) == :player1
      assert Outcome.diagonal_win(fixture.board) == false
    end

    test "num_turns_taken returns the number of turns that have be played", fixture do
      assert Outcome.num_turns_taken(fixture.board) == 0
      assert Outcome.num_turns_taken(fixture.five_moves) == 5
    end

    test "winner returns winning team atom, otherwise false", fixture do
      assert Outcome.winner(fixture.h_win) == :player1
      assert Outcome.winner(fixture.v_win) == :player1
      assert Outcome.winner(fixture.d_win) == :player1
      assert Outcome.winner(fixture.comp_win) == :player2
      assert Outcome.winner(fixture.board) == false
    end

    test "check_outcome returns :player1 if 3 1's in a row", fixture do
      assert Outcome.check_outcome(fixture.h_win) == :player1
    end

    test "check_outcome returns :player2 if 3 -1's in a row", fixture do
      assert Outcome.check_outcome(fixture.comp_win) == :player2
    end

    test "check_outcome returns :draw if no winner after nine moves played", fixture do
      assert Outcome.check_outcome(fixture.draw) == :draw
    end
  end
end
