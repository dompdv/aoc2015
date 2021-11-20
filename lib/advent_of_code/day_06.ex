defmodule AdventOfCode.Day06 do
  import Enum

  def update_lights(line, lights_on) do
    IO.inspect(line)
    %{"hx" => hx, "hy" => hy, "lx" => lx, "ly" => ly, "onoff" => onoff} =
      Regex.named_captures(
        ~r/(?<onoff>turn on|turn off|toggle) (?<hx>[0-9]*),(?<hy>[0-9]*) through (?<lx>[0-9]*),(?<ly>[0-9]*)/,
        line
      )
    hx = String.to_integer(hx)
    hy = String.to_integer(hy)
    lx = String.to_integer(lx)
    ly = String.to_integer(ly)
    g = for x <- lx..hx, y <- ly..hy, into: MapSet.new(), do: {x,y}
    case onoff do
    "turn on" -> MapSet.union(lights_on, g)
    "turn off" -> MapSet.difference(lights_on, g)
    "toggle" -> to_switch_off = MapSet.intersection(lights_on, g)
                to_switch_on = MapSet.difference(g, to_switch_off)
                MapSet.union(MapSet.difference(lights_on, to_switch_off), to_switch_on)
    end
  end

  def part1(args) do
    reduce(
      args |> String.split("\n") |> drop(-1),
      MapSet.new(),
      &update_lights/2
    )
    |> count()
  end

  def part2(_args) do
  end
end
