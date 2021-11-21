defmodule AdventOfCode.Day07 do
  use Bitwise

  def gate_set(c, wire, value), do: Map.put(c, wire, value)
  def gate_and(c, wire, wireA, wireB), do: Map.put(c, wire, c[wireA] &&& c[wireB])
  def gate_or(c, wire, wireA, wireB), do: Map.put(c, wire, c[wireA] ||| c[wireB])

  def gate_lshift(c, wire, wireA, value), do: Map.put(c, wire, c[wireA] <<< value)
  def gate_rshift(c, wire, wireA, value), do: Map.put(c, wire, c[wireA] >>> value)

  def gate_not(c, wire, wireA), do: Map.put(c, wire, ~~~c[wireA])

  def to_16bits(v), do: rem(rem(v, 65536) + 65536, 65536)


  def execute_circuit({:value, wire_out, val}, c), do: Map.put(c, wire_out, val)
  def execute_circuit({:not, wire_out, val}, c), do: Map.put(c, wire_out, val)





  def part1(args) do
    instructions = parse(args)
    Enum.reduce(
      instructions,
      %{},
      &execute_circuit/2
    )
  end

  def part2(_args) do
  end

  def parse_line(line) do
    IO.inspect(line)
    [action, wire_out] = String.split(line, " -> ")

    cond do
      String.contains?(action, " AND ") ->
        [wireA, wireB] = String.split(action, " AND ")
        {:and, wire_out, wireA, wireB}

      String.contains?(action, " OR ") ->
        [wireA, wireB] = String.split(action, " OR ")
        {:or, wire_out, wireA, wireB}

      String.contains?(action, " LSHIFT ") ->
        [wireA, val] = String.split(action, " LSHIFT ")
        {:lshift, wire_out, wireA, String.to_integer(val)}

      String.contains?(action, " RSHIFT ") ->
        [wireA, val] = String.split(action, " RSHIFT ")
        {:rshift, wire_out, wireA, String.to_integer(val)}

      String.contains?(action, "NOT ") ->
        [_, wireA] = String.split(action, "NOT ")
        {:not, wire_out, wireA}

      true -> {:value, wire_out, String.to_integer(action)}
    end
  end

  def parse(args) do
    args |> String.split("\n") |> Enum.drop(-1) |> Enum.map(&parse_line/1)
  end

  def part1_old(_args) do
    circuit = [
      fn c -> gate_set(c, "x", 123) end,
      fn c -> gate_set(c, "y", 456) end,
      fn c -> gate_and(c, "d", "x", "y") end,
      fn c -> gate_or(c, "e", "x", "y") end,
      fn c -> gate_lshift(c, "f", "x", 2) end,
      fn c -> gate_rshift(c, "g", "y", 2) end,
      fn c -> gate_not(c, "h", "x") end,
      fn c -> gate_not(c, "i", "y") end
    ]

    Enum.reduce(
      circuit,
      %{},
      fn fun_to_apply, wires_status ->
        fun_to_apply.(wires_status)
      end
    )
  end
end
