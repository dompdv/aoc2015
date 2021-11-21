defmodule AdventOfCode.Day06 do
  import Enum

  def parse_line(line) do
    %{"hx" => hx, "hy" => hy, "lx" => lx, "ly" => ly, "onoff" => onoff} =
      Regex.named_captures(
        ~r/(?<onoff>turn on|turn off|toggle) (?<hx>[0-9]*),(?<hy>[0-9]*) through (?<lx>[0-9]*),(?<ly>[0-9]*)/,
        line
      )

    onoff =
      case onoff do
        "turn on" -> 1
        "turn off" -> -1
        "toggle" -> 2
      end

    {String.to_integer(lx), String.to_integer(ly), String.to_integer(hx), String.to_integer(hy),
     onoff}
  end

  def update_lights({lx, ly, hx, hy, onoff}, lights_on) do
    g = for x <- lx..hx, y <- ly..hy, into: MapSet.new(), do: {x, y}

    case onoff do
      1 ->
        MapSet.union(lights_on, g)

      -1 ->
        MapSet.difference(lights_on, g)

      2 ->
        to_switch_off = MapSet.intersection(lights_on, g)
        to_switch_on = MapSet.difference(g, to_switch_off)
        MapSet.union(MapSet.difference(lights_on, to_switch_off), to_switch_on)
    end
  end

  def part1(args) do
    parsed_input = args |> String.split("\n") |> drop(-1) |> map(&parse_line/1)
    reduce(
      parsed_input,
      MapSet.new(),
      &update_lights/2
    )
    |> count()
  end

  def part2(_args) do
  end
end
