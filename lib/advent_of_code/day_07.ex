defmodule AdventOfCode.Day07 do
  use Bitwise

  @bin16max 65_536

  def to_16bits(v), do: rem(rem(v, @bin16max) + @bin16max, @bin16max)

  def execute_opcode(opcode, value_a, value_b) do
    case opcode do
      :and -> value_a &&& value_b
      :or -> value_a ||| value_b
      :lshift -> value_a <<< value_b
      :rshift -> value_a >>> value_b
    end
  end

  def execute_circuit(_instructions, {opcode, {:val, value}}, c, wire_out) do
    case opcode do
      :connect -> Map.put(c, wire_out, value)
      :not -> Map.put(c, wire_out, ~~~value)
    end
  end

  def execute_circuit(instructions, {opcode, {:wire, wire_from}}, c, wire_out) do
    c = wire_value(c, instructions, wire_from)

    case opcode do
      :connect -> Map.put(c, wire_out, c[wire_from])
      :not -> Map.put(c, wire_out, ~~~c[wire_from])
    end
  end

  def execute_circuit(_instructions, {opcode, {:val, value_a}, {:val, value_b}}, c, wire_out) do
    Map.put(c, wire_out, execute_opcode(opcode, value_a, value_b))
  end

  def execute_circuit(instructions, {opcode, {:val, value_a}, {:wire, wire_b}}, c, wire_out) do
    c = wire_value(c, instructions, wire_b)
    Map.put(c, wire_out, execute_opcode(opcode, value_a, c[wire_b]))
  end

  def execute_circuit(instructions, {opcode, {:wire, wire_a}, {:val, value_b}}, c, wire_out) do
    c = wire_value(c, instructions, wire_a)
    Map.put(c, wire_out, execute_opcode(opcode, c[wire_a], value_b))
  end

  def execute_circuit(instructions, {opcode, {:wire, wire_a}, {:wire, wire_b}}, c, wire_out) do
    c = wire_value(c, instructions, wire_a)
    c = wire_value(c, instructions, wire_b)
    Map.put(c, wire_out, execute_opcode(opcode, c[wire_a], c[wire_b]))
  end

  def wire_value(circuit_state, instructions, wire) do
    if Map.has_key?(circuit_state, wire) do
      circuit_state
    else
      execute_circuit(instructions, instructions[wire], circuit_state, wire)
    end
  end

  def part1(args) do
    instructions = parse(args) |> Map.new()
    res = wire_value(%{}, instructions, "a")
    res["a"]
  end

  def part2(args) do
    instructions = parse(args) |> Map.new()
    res = wire_value(%{}, instructions, "a")
    res = wire_value(%{"b" => res["a"]}, instructions, "a")
    res["a"]
  end

  def to_v(value) do
    if Integer.parse(value) == :error, do: {:wire, value}, else: {:val, String.to_integer(value)}
  end

  def parse_line(line) do
    [action, wire_out] = String.split(line, " -> ")

    cond do
      String.contains?(action, " AND ") ->
        [wire_a, wire_b] = String.split(action, " AND ")
        {wire_out, {:and, to_v(wire_a), to_v(wire_b)}}

      String.contains?(action, " OR ") ->
        [wire_a, wire_b] = String.split(action, " OR ")
        {wire_out, {:or, to_v(wire_a), to_v(wire_b)}}

      String.contains?(action, " LSHIFT ") ->
        [wire_a, val] = String.split(action, " LSHIFT ")
        {wire_out, {:lshift, to_v(wire_a), to_v(val)}}

      String.contains?(action, " RSHIFT ") ->
        [wire_a, val] = String.split(action, " RSHIFT ")
        {wire_out, {:rshift, to_v(wire_a), to_v(val)}}

      String.contains?(action, "NOT ") ->
        [_, wire_a] = String.split(action, "NOT ")
        {wire_out, {:not, to_v(wire_a)}}

      true ->
        {wire_out, {:connect, to_v(action)}}
    end
  end

  def parse(args) do
    args |> String.split("\n") |> Enum.drop(-1) |> Enum.map(&parse_line/1)
  end
end
