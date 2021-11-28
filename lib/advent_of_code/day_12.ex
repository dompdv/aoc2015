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

  def add_numbers2(s) when is_number(s), do: s
  def add_numbers2(s) when is_bitstring(s), do: 0
  def add_numbers2([]), do: 0
  def add_numbers2(l) when is_list(l), do: map(l, fn v -> add_numbers2(v) end) |> sum()

  def add_numbers2(m) when is_map(m) do
    values = Map.values(m)
    if Enum.member?(values, "red"), do: 0, else: map(values, fn v -> add_numbers2(v) end) |> sum()
  end

  def part2(args) do
    {:ok, a} = Jason.decode(args)
    add_numbers2(a)
  end
end
