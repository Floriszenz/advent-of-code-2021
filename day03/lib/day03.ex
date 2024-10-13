defmodule Day03 do
  import Bitwise

  def calculate_power_consumption() do
    {:ok, file} = File.open("../data/day03-input.txt", [:read])

    gamma_rate_str =
      IO.stream(file, :line)
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn bit -> String.to_integer(bit) end))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))
      |> Enum.map(&(Enum.sum(&1) / Enum.count(&1)))
      |> Enum.map(fn
        bit when bit > 0.5 -> 1
        _ -> 0
      end)
      |> Enum.join()

    gamma_rate = String.to_integer(gamma_rate_str, 2)

    epsilon_rate = bxor(gamma_rate, (1 <<< String.length(gamma_rate_str)) - 1)
    power_consumption = gamma_rate * epsilon_rate

    IO.puts("The power consumption of the submarine is #{power_consumption}")
    File.close(file)
  end

  def calculate_life_support_rating() do
    {:ok, file} = File.open("../data/day03-input.txt", [:read])

    diagnostic_report =
      IO.stream(file, :line)
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn bit -> String.to_integer(bit) end))

    oxygen_generator_rating =
      find_rating(diagnostic_report, :oxygen)
      |> Enum.join()
      |> String.to_integer(2)

    co2_scrubber_rating =
      find_rating(diagnostic_report, :carbon)
      |> Enum.join()
      |> String.to_integer(2)

    life_support_rating = oxygen_generator_rating * co2_scrubber_rating

    IO.puts("The life support rating of the submarine is #{life_support_rating}")
    File.close(file)
  end

  defp find_rating(list, type, bit_pos \\ 0)

  defp find_rating(list, _, _) when length(list) == 1 do
    Enum.at(list, 0)
  end

  defp find_rating(list, type, bit_pos) do
    filter_bit = determine_filter_bit(list, type, bit_pos)
    filtered_list = Enum.filter(list, &(Enum.at(&1, bit_pos) == filter_bit))

    find_rating(filtered_list, type, bit_pos + 1)
  end

  defp determine_filter_bit(list, type, bit_pos) do
    ones_count = Enum.map(list, &Enum.at(&1, bit_pos)) |> Enum.sum()
    zeros_count = length(list) - ones_count

    case {ones_count, zeros_count, type} do
      {x, x, :oxygen} -> 1
      {x, x, :carbon} -> 0
      {x, y, :oxygen} when x > y -> 1
      {_, _, :oxygen} -> 0
      {x, y, :carbon} when x > y -> 0
      {_, _, :carbon} -> 1
    end
  end
end
