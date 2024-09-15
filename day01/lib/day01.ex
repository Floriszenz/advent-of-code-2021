defmodule Day01 do
  def depth_measurement_increases() do
    {:ok, file} = File.open("../data/day01-input.txt", [:read])

    depth_increases =
      IO.stream(file, :line)
      |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [current_depth, next_depth] -> next_depth - current_depth end)
      |> Enum.filter(&(&1 > 0))
      |> Enum.count()

    IO.puts("The depth measurements increase #{depth_increases} times.")
    File.close(file)
  end

  def depth_measurement_in_sliding_windows_increases() do
    {:ok, file} = File.open("../data/day01-input.txt", [:read])

    depth_increases =
      IO.stream(file, :line)
      |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&Enum.sum(&1))
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [current_depth, next_depth] -> next_depth - current_depth end)
      |> Enum.filter(&(&1 > 0))
      |> Enum.count()

    IO.puts("The depth measurements in sliding windows increase #{depth_increases} times.")
    File.close(file)
  end
end
