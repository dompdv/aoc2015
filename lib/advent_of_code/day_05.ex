defmodule AdventOfCode.Day05 do
  import Enum

  @vowels MapSet.new('aeiou')
  @caracters ~w"aa bb cc dd ee ff gg hh ii jj kk ll mm nn oo pp qq rr ss tt uu vv ww xx yy zz"
  @to_avoid ~w"ab cd pq xy"

  def check_conditions(args) do
    string = to_charlist(args)
    vowels = (filter(string, fn c -> MapSet.member?(@vowels, c) end) |> count()) >= 3
    double = String.contains?(args, @caracters)
    avoid = not String.contains?(args, @to_avoid)
    if vowels and double and avoid, do: 1, else: 0
  end
  def part1(args) do
    args |> String.split("\n") |> drop(-1) |> map(&check_conditions/1) |> sum()
  end

  def part2(_args) do
  end
end
