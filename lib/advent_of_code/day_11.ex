defmodule AdventOfCode.Day11 do
  import Enum

  @forbidden_letters MapSet.new([?i - ?a, ?o - ?a, ?l - ?a])

  def contains_forbidden_letters(chars),
    do: MapSet.size(MapSet.intersection(MapSet.new(chars), @forbidden_letters)) != 0

  def contains_3sequence([_a, _b]), do: false
  def contains_3sequence([_a]), do: false
  def contains_3sequence([]), do: false

  def contains_3sequence([a, b, c | r]),
    do: if(a + 1 == b and a + 2 == c, do: true, else: contains_3sequence([b, c | r]))

  def remove_overlapping([], acc), do: acc
  def remove_overlapping([a], acc), do: [a | acc]

  def remove_overlapping([a, b | r], acc),
    do:
      if(a - 1 == b, do: remove_overlapping(r, acc), else: remove_overlapping([b | r], [a | acc]))

  def contains_2sequence(chars),
    do: count(contains_2sequence(chars, 0, []) |> remove_overlapping([])) >= 2

  def contains_2sequence([], _, sequences_positions), do: sequences_positions
  def contains_2sequence([_], _, sequences_positions), do: sequences_positions

  def contains_2sequence([a, a | r], index, sequences_positions),
    do: contains_2sequence([a | r], index + 1, [index | sequences_positions])

  def contains_2sequence([_ | r], index, sequences_positions),
    do: contains_2sequence(r, index + 1, sequences_positions)

  def check_password(chars) do
    cond do
      contains_forbidden_letters(chars) -> false
      contains_3sequence(chars) and contains_2sequence(chars) -> true
      true -> false
    end
  end

  def b26_to_integer(chars) do
    {_, res} = reduce(reverse(chars), {1, 0}, fn n, {mul, acc} -> {mul * 26, acc + mul * n} end)
    res
  end

  def integer_to_b26(n), do: integer_to_b26(n, [])

  def integer_to_b26(n, l) when n < 26, do: [n | l]
  def integer_to_b26(n, l), do: integer_to_b26(div(n, 26), [rem(n, 26) | l])

  def next_sequence(chars), do: integer_to_b26(1 + b26_to_integer(chars))

  def print_password(chars), do: map(chars, fn c -> c + ?a end)

  def part1(args) do
    initial = args |> to_charlist() |> map(fn c -> c - ?a end)

    [next_password] =
      Stream.iterate(next_sequence(initial), fn chars -> next_sequence(chars) end)
      |> Stream.filter(&check_password/1)
      |> Enum.take(1)

    print_password(next_password)
  end

  def part2(args) do
    part1(args)
  end
end
