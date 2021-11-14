defmodule AdventOfCode.Day03 do
  import Enum

  @possible_moves %{62 => {1, 0}, 60 => {-1, 0}, 94 => {0, 1}, 118 => {0, -1}}
  def move([], _, visited), do: count(visited)

  def move([new_move | rest], {santa_pos_x, santa_pos_y}, visited) do
    {dx, dy} = @possible_moves[new_move]

    move(
      rest,
      {santa_pos_x + dx, santa_pos_y + dy},
      visited |> MapSet.put({santa_pos_x + dx, santa_pos_y + dy})
    )
  end

  def part1(args) do
    args |> to_charlist() |> move({0, 0}, MapSet.new([{0, 0}]))
  end

  def move2([], _, _, _, visited), do: count(visited)

  def move2(
        [new_move | rest],
        {santa_pos_x, santa_pos_y},
        {robo_santa_pos_x, robo_santa_pos_y},
        turn,
        visited
      ) do
    {dx, dy} = @possible_moves[new_move]

    {santa_pos_x, santa_pos_y, robo_santa_pos_x, robo_santa_pos_y} =
      case turn do
        1 -> {santa_pos_x + dx, santa_pos_y + dy, robo_santa_pos_x, robo_santa_pos_y}
        -1 -> {santa_pos_x, santa_pos_y, robo_santa_pos_x + dx, robo_santa_pos_y + dy}
      end

    move2(
      rest,
      {santa_pos_x, santa_pos_y},
      {robo_santa_pos_x, robo_santa_pos_y},
      -turn,
      visited |> MapSet.put({santa_pos_x, santa_pos_y}) |> MapSet.put({robo_santa_pos_x, robo_santa_pos_y})
    )
  end

  def part2(args) do
    args |> to_charlist() |> move2({0, 0}, {0, 0}, 1, MapSet.new([{0, 0}]))
  end
end
