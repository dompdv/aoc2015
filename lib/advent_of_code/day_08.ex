defmodule AdventOfCode.Day08 do
  import Enum

  def rlength(line), do: rlength(line, 0)

  def rlength([], l), do: l - 2
  def rlength([?\\, ?\\ | r], l), do: rlength(r, l + 1)
  def rlength([?\\, ?" | r], l), do: rlength(r, l + 1)
  def rlength([?\\, ?x, _, _ | r], l), do: rlength(r, l + 1)
  def rlength([_ | r], l), do: rlength(r, l + 1)

  def part1(args) do
    args
    |> String.split("\n")
    |> drop(-1)
    |> map(fn line ->
      cl = to_charlist(line)
      count(cl) - rlength(cl)
    end)
    |> sum()
  end

  def encode(line), do: encode(line, 0)

  def encode([], l), do: l + 2
  def encode([?" | r], l), do: encode(r, l + 2)
  def encode([?\\ | r], l), do: encode(r, l + 2)
  def encode([_ | r], l), do: encode(r, l + 1)

  def part2(args) do
    args
    |> String.split("\n")
    |> drop(-1)
    |> map(fn line ->
      cl = to_charlist(line)
      encode(cl) - count(cl)
    end)
    |> sum()
  end
end
