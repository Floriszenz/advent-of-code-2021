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
end
