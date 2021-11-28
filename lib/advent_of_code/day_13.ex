defmodule AdventOfCode.Day13 do
  import Enum

  def parse_line(str) do
    [p1, _, sign, happyness, _, _, _, _, _, _, p2] = String.slice(str, 0..-2) |> String.split()
    {{p1, p2}, if(sign == "gain", do: 1, else: -1) * String.to_integer(happyness)}
  end

  def total_happiness(graph, [], disposition) do
    {first, rest} = List.pop_at(disposition, 0)
    circle = List.zip([disposition, rest ++ [first]])
    sum(for {p1, p2} <- circle, do: graph[{p1, p2}] + graph[{p2, p1}])
  end

  def total_happiness(graph, people, disposition) do
    max(for p <- people, do: total_happiness(graph, List.delete(people, p), [p | disposition]))
  end

  def part1(args) do
    graph = args |> String.split("\n") |> drop(-1) |> map(&parse_line/1) |> Map.new()
    people = Map.keys(graph) |> map(fn {p1, p2} -> [p1, p2] end) |> List.flatten() |> uniq()
    total_happiness(graph, people, [])
  end

  def part2(args) do
    graph = args |> String.split("\n") |> drop(-1) |> map(&parse_line/1) |> Map.new()
    people = Map.keys(graph) |> map(fn {p1, p2} -> [p1, p2] end) |> List.flatten() |> uniq()
    graph = for p <- people, into: graph, do: {{"moi", p}, 0}
    graph = for p <- people, into: graph, do: {{p, "moi"}, 0}
    people = people ++ ["moi"]
    total_happiness(graph, people, [])
  end
end
