defmodule AdventOfCode.Day09 do
  def parse(args) do
    parsed =
      args
      |> String.split("\n")
      |> Enum.drop(-1)
      |> Enum.map(fn line ->
        [from, _, to, _, d] = String.split(line, " ")
        [{from, to, String.to_integer(d)}, {to, from, String.to_integer(d)}]
      end)
      |> List.flatten()

    {for({from, to, d} <- parsed, into: %{}, do: {{from, to}, d}),
     for({from, to, _} <- parsed, do: [from, to]) |> List.flatten() |> MapSet.new()}
  end

  def visit(graph, city, cities, distance) do
    cities = MapSet.delete(cities, city)

    if cities == MapSet.new(),
      do: distance,
      else: Enum.min(for c <- cities, do: visit(graph, c, cities, distance + graph[{city, c}]))
  end

  def part1(args) do
    {graph, cities} = parse(args)
    Enum.min(for c <- cities, do: visit(graph, c, cities, 0))
  end

  def visit2(graph, city, cities, distance) do
    cities = MapSet.delete(cities, city)

    if cities == MapSet.new(),
      do: distance,
      else: Enum.max(for c <- cities, do: visit2(graph, c, cities, distance + graph[{city, c}]))
  end

  def part2(args) do
    {graph, cities} = parse(args)
    Enum.max(for c <- cities, do: visit2(graph, c, cities, 0))
  end
end
