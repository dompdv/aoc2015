defmodule AdventOfCode.Day05 do
  import Enum

  @vowels MapSet.new('aeiou')
  @caracters ~w"aa bb cc dd ee ff gg hh ii jj kk ll mm nn oo pp qq rr ss tt uu vv ww xx yy zz"
  @to_avoid ~w"ab cd pq xy"

  def check_conditions(args) do
    string = to_charlist(args)
    vowels = filter(string, fn c -> MapSet.member?(@vowels, c) end) |> count() >= 3
    double = String.contains?(args, @caracters)
    avoid = not String.contains?(args, @to_avoid)
    if vowels and double and avoid, do: 1, else: 0
  end

  def part1(args) do
    args |> String.split("\n") |> drop(-1) |> map(&check_conditions/1) |> sum()
  end

  def car_repeats([]), do: false
  def car_repeats([_]), do: false
  def car_repeats([_, _]), do: false
  def car_repeats([a, _, a | _]), do: true
  def car_repeats([_, b, c | d]), do: car_repeats([b, c | d])

  def check_conditions2(args) do
    cr = car_repeats(to_charlist(args))
    pair = Regex.match?(~r/([a-z][a-z]).*\1/, args)
    if pair and cr, do: 1, else: 0
  end

  def part2(args) do
    args |> String.split("\n") |> drop(-1) |> map(&check_conditions2/1) |> sum()
  end
end
