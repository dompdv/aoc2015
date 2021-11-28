defmodule AdventOfCode.Day12 do
  import Enum

  def add_numbers(s) when is_number(s), do: s
  def add_numbers(s) when is_bitstring(s), do: 0
  def add_numbers([]), do: 0
  def add_numbers(l) when is_list(l), do: map(l, fn v -> add_numbers(v) end) |> sum()
  def add_numbers(m) when is_map(m), do: map(Map.values(m), fn v -> add_numbers(v) end) |> sum()

  def part1(args) do
    {:ok, a} = Jason.decode(args)
    add_numbers(a)
  end

  def part2(_args) do
  end
end
