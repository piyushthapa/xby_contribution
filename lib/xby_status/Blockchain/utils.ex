defmodule XbyStatus.Blockchain.Utils do

  @wei_factor 1_000_000_000_000_000000
  @sat_factor 100_000_000
  def wei_to_eth(value) when is_binary(value) do
    value
    |> to_float()
    |> wei_to_eth()
  end

  def wei_to_eth(value) when is_float(value) do
    value / @wei_factor
  end

  def wei_to_eth(_), do: nil

  def sat_to_btc(value) when is_binary(value) do
    IO.inspect value

    value
    |> to_float()
    |> sat_to_btc()
  end

  def sat_to_btc(value) when is_float(value) do
    value / @sat_factor
  end

  def sat_to_btc(_), do: nil


  def to_float(value) when is_binary(value) do
    Float.parse(value)
    |> to_float()
  end

  def to_float({value, _}), do: value
  def to_float(_), do: nil

end
