defmodule AdventOfCode.Day02 do
  import Enum

  def part1(args) do
    parse(args)
    |> map(fn [l, w, h] -> 2 * (l * w + l * h + w * h) + min([l * w, l * h, w * h]) end)
    |> sum
  end

  def part2(args) do
    parse(args)
    |> map(fn [l, w, h] -> l * w * h + 2 * min([l + w, l + h, w + h]) end)
    |> sum
  end

  def parse(args) do
    args
    |> String.split("\n")
    |> drop(-1)
    |> map(fn s -> String.split(s, "x") |> map(fn n -> String.to_integer(n) end) end)
  end
end
