defmodule AdventOfCode.Day10 do
  import Enum
  def sequence(str), do: Enum.reverse(sequence(str, nil, []))
  def sequence([], _, s), do: s

  def sequence([c | r], nil, []), do: sequence(r, c, [[c]])

  def sequence([c | r], last_char, [s | r_sequences]) do
    if c == last_char,
      do: sequence(r, last_char, [[c | s] | r_sequences]),
      else: sequence(r, c, [[c], s | r_sequences])
  end

  def iterate(str) do
    sequence(str)
    |> map(fn one_seq -> "#{count(one_seq)}#{[List.first(one_seq)]}" end)
    |> Enum.join()
    |> to_charlist()
  end

  def part1({n, str}) do
    reduce(1..n, to_charlist(str), fn _, acc -> iterate(acc) end)
    |> count()
  end

  def part2(_args) do
  end
end
