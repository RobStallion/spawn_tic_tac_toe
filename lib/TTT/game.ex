defmodule TTT.Game do
  alias TTT.Outcome

  def make_move(pid, move_pid) do
    receive do
      {:human, board, tile, team } ->
        updated_board = update_board(board, tile, team)
        case Outcome.check_outcome(updated_board) do
          :win ->
            send(move_pid, :end)
            send(pid, {:human_win, updated_board})
          :draw ->
            send(pid, {:draw, updated_board})
          :false ->
            send(move_pid, {self(), team, updated_board})
            make_move(pid, move_pid)
        end
      {:comp, board, tile, team } ->
        updated_board = update_board(board, tile, team)
        case Outcome.check_outcome(updated_board) do
          :win ->
            send(move_pid, :end)
            send(pid, {:comp_win, updated_board})
          :draw ->
            send(pid, {:draw, updated_board})
          :false ->
            send(move_pid, {self(), team, updated_board})
            make_move(pid, move_pid)
        end
    end
  end

  def run(tile) do
    move_pid = spawn(TTT.Game, :move, [])
    make_move_pid  = spawn(TTT.Game, :make_move, [self(), move_pid])

    send(make_move_pid, {:human, create_board(), tile, 1})

    receive do
      {:human_win, board} ->
        IO.inspect board, label: "You Win!!"
      {:comp_win, board} ->
        IO.inspect board, label: "Computer Wins"
      {:draw, board} ->
        IO.inspect board, label: "It's a draw"
    end
  end

  def move() do
    receive do
      {make_move_pid, tile, board} ->
        case tile do
          -1 ->
            send(make_move_pid, { :human, board, get_player_move(board), 1})
            move()
          1 ->
            send(make_move_pid, { :comp, board, get_comp_move(board), -1 })
            move()
          :end ->
            exit(:normal)
        end
    end
  end

  def create_board do
    for _x <- 1..9, do: 0
  end

  def update_board(board, tile, team) do
    List.replace_at(board, tile, team)
  end

  # not sure how to test this
  def get_player_move(board) do
    IO.inspect(board)
    IO.gets("What is you move?\n")
    |> String.split
    |> hd
    |> String.to_integer
  end

  def get_comp_move(board) do
    board
    |> Enum.with_index
    |> Enum.filter(fn {x, _} -> x == 0 end)
    |> Enum.random
    |> Tuple.to_list
    |> Enum.at(1)
  end
end
