defmodule AdventOfCode.Day07 do
  use Bitwise

  @bin16max 65_536

  def to_16bits(v), do: rem(rem(v, @bin16max) + @bin16max, @bin16max)

  def execute_circuit({:value, wire_out, val}, c), do: Map.put(c, wire_out, val)

  def execute_circuit({:connect, wire_out, wire_from}, c), do: Map.put(c, wire_out, c[wire_from])

  def execute_circuit({:and, wire_out, wire_a, wire_b}, c),
    do: Map.put(c, wire_out, c[wire_a] &&& c[wire_b])

  def execute_circuit({:or, wire_out, wire_a, wire_b}, c),
    do: Map.put(c, wire_out, c[wire_a] ||| c[wire_b])

  def execute_circuit({:lshift, wire_out, wire_a, value}, c),
    do: Map.put(c, wire_out, c[wire_a] <<< value)

  def execute_circuit({:rshift, wire_out, wire_a, value}, c),
    do: Map.put(c, wire_out, c[wire_a] >>> value)

  def execute_circuit({:not, wire_out, wire_a}, c), do: Map.put(c, wire_out, ~~~c[wire_a])

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
        [wire_a, wire_b] = String.split(action, " AND ")
        {:and, wire_out, wire_a, wire_b}

      String.contains?(action, " OR ") ->
        [wire_a, wire_b] = String.split(action, " OR ")
        {:or, wire_out, wire_a, wire_b}

      String.contains?(action, " LSHIFT ") ->
        [wire_a, val] = String.split(action, " LSHIFT ")
        {:lshift, wire_out, wire_a, String.to_integer(val)}

      String.contains?(action, " RSHIFT ") ->
        [wire_a, val] = String.split(action, " RSHIFT ")
        {:rshift, wire_out, wire_a, String.to_integer(val)}

      String.contains?(action, "NOT ") ->
        [_, wire_a] = String.split(action, "NOT ")
        {:not, wire_out, wire_a}

      Integer.parse(action) ->
        {:connect, wire_out, action}

      true ->
        {:value, wire_out, String.to_integer(action)}
    end
  end

  def parse(args) do
    args |> String.split("\n") |> Enum.drop(-1) |> Enum.map(&parse_line/1)
  end

  def gate_set(c, wire, value), do: Map.put(c, wire, value)
  def gate_and(c, wire, wire_a, wire_b), do: Map.put(c, wire, c[wire_a] &&& c[wire_b])
  def gate_or(c, wire, wire_a, wire_b), do: Map.put(c, wire, c[wire_a] ||| c[wire_b])

  def gate_lshift(c, wire, wire_a, value), do: Map.put(c, wire, c[wire_a] <<< value)
  def gate_rshift(c, wire, wire_a, value), do: Map.put(c, wire, c[wire_a] >>> value)

  def gate_not(c, wire, wire_a), do: Map.put(c, wire, ~~~c[wire_a])

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
