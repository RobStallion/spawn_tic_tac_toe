defmodule TTT.Outcome do
  def check_outcome(board) do
    cond do
      winner(board) -> winner(board) #someone won
      num_turns_taken(board) == 9 -> :draw
      true -> false #another move needs to be played
    end
  end

  def winner(board) do
    horizontal_win(board) || vertical_win(board) || diagonal_win(board)
  end

  def horizontal_win(board) do
    [h1, h2, h3] =
      Enum.chunk(board, 3)
      |> Enum.map(&three_in_a_row/1)

    h1 || h2 || h3
  end

  def vertical_win([t1,t2,t3,t4,t5,t6,t7,t8,t9]) do
    [v1, v2, v3] =
      [[t1, t4, t7], [t2, t5, t8], [t3, t6, t9]]
      |> Enum.map(&three_in_a_row/1)

    v1 || v2 || v3
  end

  def diagonal_win([t1,_,t3,_,t5,_,t7,_,t9]) do
    three_in_a_row([t1, t5, t9]) || three_in_a_row([t3,t5,t7])
  end

  def three_in_a_row(list) do
    case Enum.sum(list) do
      3  -> :player1
      -3 -> :player2
      _  -> false
    end
  end

  def num_turns_taken(board) do
    Enum.filter(board, &(&1 != 0)) |> length
  end
end
