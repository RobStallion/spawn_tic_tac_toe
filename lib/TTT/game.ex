defmodule TTT.Game do
  alias TTT.Outcome

  def check_result(pid, get_move_pid) do
    receive do
      { board, tile, team } ->
        updated_board = update_board(board, tile, team)
        case Outcome.check_outcome(updated_board) do
          :draw ->
            send(pid, {:draw, updated_board})
          :false ->
            send(get_move_pid, {self(), team, updated_board})
            check_result(pid, get_move_pid)
          player ->
            send(get_move_pid, :end)
            send(pid, {:win, player, updated_board})
        end
    end
  end

  def run(tile) do
    get_move_pid = spawn(TTT.Game, :get_move, [])
    check_result_pid  = spawn(TTT.Game, :check_result, [self(), get_move_pid])

    send(check_result_pid, {create_board(), tile, 1})

    receive do
      {:win, player, board} ->
        IO.inspect board, label: "#{player} Wins!!"
      {:draw, board} ->
        IO.inspect board, label: "It's a draw"
    end
  end

  def get_move() do
    receive do
      {check_result_pid, just_played, board} ->
        next_to_play = if just_played == -1, do: 1, else: -1
        next_tile = if just_played == -1, do: get_player_move(board), else: get_comp_move(board)

        send(check_result_pid, { board, next_tile, next_to_play })
        get_move()
      :end ->
        exit(:normal)
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
