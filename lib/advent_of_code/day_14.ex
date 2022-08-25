defmodule AdventOfCode.Day14 do
  @exp_in ~r/([a-z,A-Z]+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./

  def distance(t, speed, duration, rest) do
    cycle = duration + rest
    cycles = div(t, cycle) * speed * duration
    after_cycles = min(rem(t, cycle), duration) * speed
    cycles + after_cycles
  end

  def distance(t, {who, speed, duration, rest}), do: {who, distance(t, speed, duration, rest)}

  def parse_line(line) do
    [_, who, speed, duration, rest] = Regex.run(@exp_in, line)
    {who, String.to_integer(speed), String.to_integer(duration), String.to_integer(rest)}
  end

  def parse(args), do: args |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)

  def part1(args),
    do:
      parse(args)
      |> Enum.map(fn reindeer -> distance(2503, reindeer) end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

  def part2(_args) do
  end
end
