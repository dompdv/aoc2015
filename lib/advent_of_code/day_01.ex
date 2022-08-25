defmodule AdventOfCode.Day01 do
  import Enum

  def part1(args) do
    counts = args |> to_charlist() |> frequencies()
    counts[?(] - counts[?)]
  end

  def to_basement(_, -1, position), do: position

  def to_basement([action | actions], level, position) do
    case action do
      ?( -> to_basement(actions, level + 1, position + 1)
      ?) -> to_basement(actions, level - 1, position + 1)
    end
  end

  def part2(args), do: to_basement(args |> to_charlist(), 0, 0)
end
