defmodule Day02 do
  def final_position_product() do
    {:ok, file} = File.open("../data/day02-input.txt", [:read])

    %{forward: forward, down: down, up: up} =
      IO.stream(file, :line)
      |> Enum.map(&String.split(&1))
      |> Enum.map(fn [command, steps] -> {parse_movement(command), String.to_integer(steps)} end)
      |> Enum.reduce(%{}, fn {command, steps}, acc ->
        Map.update(acc, command, steps, &(&1 + steps))
      end)

    depth = down - up
    horizontal_movement = forward

    movement_product = depth * horizontal_movement

    IO.puts("The product of the final depth and horizontal movement is #{movement_product}")
    File.close(file)
  end

  def final_position_product_with_aim() do
    {:ok, file} = File.open("../data/day02-input.txt", [:read])

    %{forward: forward, depth: depth} =
      IO.stream(file, :line)
      |> Enum.map(&String.split(&1))
      |> Enum.map(fn [command, steps] -> {parse_movement(command), String.to_integer(steps)} end)
      |> Enum.reduce(%{forward: 0, depth: 0, aim: 0}, fn {command, steps}, acc ->
        case command do
          :forward -> %{acc | forward: acc.forward + steps, depth: acc.depth + acc.aim * steps}
          :down -> %{acc | aim: acc.aim + steps}
          :up -> %{acc | aim: acc.aim - steps}
        end
      end)

    movement_product = depth * forward

    IO.puts(
      "The product of the final depth and horizontal movement with aim is #{movement_product}"
    )

    File.close(file)
  end

  defp parse_movement(command) do
    case command do
      "forward" -> :forward
      "down" -> :down
      "up" -> :up
      _ -> :unknown
    end
  end
end
