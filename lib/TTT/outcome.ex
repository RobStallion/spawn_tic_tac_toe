defmodule TTT.Outcome do
  def check_outcome(board) do
    cond do
      !poss?(board) -> false #not possible for a win yet
      winner?(board) -> :win #someone won
      draw?(board) -> :draw #the game was a draw
      true -> false #another move needs to be played
    end
  end

  def poss?(board) do
    if (num_turns_taken(board) < 5), do: false, else: true
  end

  def winner?(board) do
    horizontal_win?(board) || vertical_win?(board) || diagonal_win?(board)
  end

  def draw?(board) do
    if (num_turns_taken(board) == 9), do: true, else: false
  end

  def horizontal_win?(board) do
    board
    |> Enum.chunk(3)
    |> Enum.any?(&(three_in_a_row?/1))
  end

  def vertical_win?([t1,t2,t3,t4,t5,t6,t7,t8,t9]) do
    [[t1, t4, t7], [t2, t5, t8], [t3, t6, t9]]
    |> Enum.any?(&(three_in_a_row?/1))
  end

  def diagonal_win?([t1,_,t3,_,t5,_,t7,_,t9]) do
    three_in_a_row?([t1, t5, t9]) || three_in_a_row?([t3,t5,t7])
  end

  def three_in_a_row?(list) do
    Enum.sum(list) == 3 || Enum.sum(list) == -3
  end

  def num_turns_taken(board) do
    Enum.filter(board, &(&1 != 0)) |> length
  end
end
