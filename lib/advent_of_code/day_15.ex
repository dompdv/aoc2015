defmodule AdventOfCode.Day15 do
  @exp_in ~r/([a-z,A-Z]+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/

  def to_integer_when_possible(a) do
    case(Integer.parse(a)) do
      :error -> a
      {i, _} -> i
    end
  end

  def parse_line(line),
    do: Regex.run(@exp_in, line, capture: :all_but_first) |> Enum.map(&to_integer_when_possible/1)

  def parse(args), do: args |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)

  def compose(ingredients, qty) do
    Enum.reduce(
      Enum.zip(ingredients, qty),
      [0, 0, 0, 0],
      fn {[_, na, nb, nc, nd, _], q}, [a, b, c, d] ->
        [a + q * na, b + q * nb, c + q * nc, d + q * nd]
      end
    )
    |> Enum.map(fn a -> if a < 0, do: 0, else: a end)
    |> Enum.reduce(1, fn n, a -> n * a end)
  end

  def compose2(ingredients, qty) do
    [a, b, c, d, cal] =
      Enum.reduce(
        Enum.zip(ingredients, qty),
        [0, 0, 0, 0, 0],
        fn {[_, na, nb, nc, nd, ncal], q}, [a, b, c, d, cal] ->
          [a + q * na, b + q * nb, c + q * nc, d + q * nd, cal + q * ncal]
        end
      )

    if cal != 500 do
      0
    else
      [a, b, c, d]
      |> Enum.map(fn a -> if a < 0, do: 0, else: a end)
      |> Enum.reduce(1, fn n, a -> n * a end)
    end
  end

  def part1(args) do
    ingredients = parse(args)

    for(
      a <- 0..100,
      b <- 0..100,
      c <- 0..100,
      a + b + c <= 100,
      do: compose(ingredients, [a, b, c, 100 - a - b - c])
    )
    |> Enum.max()
  end

  def part2(args) do
    ingredients = parse(args)

    for(
      a <- 0..100,
      b <- 0..100,
      c <- 0..100,
      a + b + c <= 100,
      do: compose2(ingredients, [a, b, c, 100 - a - b - c])
    )
    |> Enum.max()
  end
end
