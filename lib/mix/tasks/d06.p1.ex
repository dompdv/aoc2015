defmodule Mix.Tasks.D06.P1 do
  use Mix.Task

  import AdventOfCode.Day06

  @shortdoc "Day 06 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(6, 2015)

    """
    turn on 0,0 through 3,3
    turn off 1,1 through 2,2
    toggle 2,2 through 3,3
    """

    # AdventOfCode.Input.get!(6, 2015) #"turn on 498,499 through 500,501\n"

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
