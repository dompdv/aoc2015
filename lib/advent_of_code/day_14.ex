defmodule AdventOfCode.Day14 do
  @exp_in ~r/([a-z,A-Z]+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./

  def parse_line(line) do
    [_, who, speed, duration, rest] = Regex.run(@exp_in, line)
    {who, String.to_integer(speed), String.to_integer(duration), String.to_integer(rest)}
  end

  def parse(args), do: args |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)

  def distance(t, speed, duration, rest) do
    cycle = duration + rest
    cycles = div(t, cycle) * speed * duration
    after_cycles = min(rem(t, cycle), duration) * speed
    cycles + after_cycles
  end

  def distance(t, {who, speed, duration, rest}), do: {who, distance(t, speed, duration, rest)}

  def part1(args),
    do:
      parse(args)
      |> Enum.map(fn reindeer -> distance(2503, reindeer) end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

  def tick_one(
        %{status: :running, rest: rest, countdown: 1, distance: distance, speed: speed} = runner
      ),
      do: %{runner | status: :resting, countdown: rest, distance: distance + speed}

  def tick_one(%{status: :resting, duration: duration, countdown: 1} = runner),
    do: %{runner | status: :running, countdown: duration}

  def tick_one(
        %{status: :running, countdown: countdown, distance: distance, speed: speed} = runner
      ),
      do: %{runner | countdown: countdown - 1, distance: distance + speed}

  def tick_one(%{status: :resting, countdown: countdown} = runner),
    do: %{runner | countdown: countdown - 1}

  def tick(runners) do
    runners = Enum.map(runners, &tick_one/1)
    pole_position = runners |> Enum.map(& &1.distance) |> Enum.max()

    Enum.map(runners, fn %{score: score, distance: distance} = runner ->
      %{runner | score: score + if(distance == pole_position, do: 1, else: 0)}
    end)
  end

  def part2(args) do
    runners =
      parse(args)
      |> Enum.map(fn {name, speed, duration, rest} ->
        %{
          name: name,
          speed: speed,
          duration: duration,
          rest: rest,
          status: :running,
          countdown: duration,
          distance: 0,
          score: 0
        }
      end)

    Enum.reduce(1..2503, runners, fn _, r -> tick(r) end) |> Enum.map(& &1.score) |> Enum.max()
  end
end
