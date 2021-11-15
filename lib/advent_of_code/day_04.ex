defmodule AdventOfCode.Day04 do
  import Enum

  def check(secret, number) do
    s_number = Integer.to_string(number)
    <<a,b,c, _d::binary>> = :crypto.hash(:md5 , "#{secret}#{s_number}")
    {number, not(a == 0 and b == 0 and c < 16)}
  end
  def part1(args) do
    Stream.iterate(1, & &1 + 1)
    |> Stream.map(fn n -> check(args, n) end)
    |> Stream.drop_while(fn {_, stop} -> stop end)
    |> take(1)
  end

  def check2(secret, number) do
    s_number = Integer.to_string(number)
    <<a,b,c, _d::binary>> = :crypto.hash(:md5 , "#{secret}#{s_number}")
    {number, not(a == 0 and b == 0 and c == 0)}
  end

  def part2(args) do
    Stream.iterate(1, & &1 + 1)
    |> Stream.map(fn n -> check2(args, n) end)
    |> Stream.drop_while(fn {_, stop} -> stop end)
    |> take(1)
  end
end
