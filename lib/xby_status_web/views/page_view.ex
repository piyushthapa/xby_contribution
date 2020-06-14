defmodule XbyStatusWeb.PageView do
  use XbyStatusWeb, :view

  def get_balance(coin) when is_map(coin) do
    cond do
      is_nil(Map.get(coin, :balance)) ->
        "NA"

      is_nil(Map.get(coin, :goal)) ->
        "#{coin.balance}  #{coin.symbol}"

      true ->
        "#{coin.balance} / #{coin.goal}  #{coin.symbol}"
    end
  end

  def get_percentage(coin) when is_map(coin) do
    cond do
      is_nil(Map.get(coin, :balance)) ->
        nil

      is_nil(Map.get(coin, :goal)) ->
        nil

      true ->
        (coin.balance/coin.goal) * 100
    end
  end

  def get_explorer_url(coin) do
    case Map.get(coin, :tx_lookup_url) do
      nil -> nil

      url ->
        url
        |> String.replace("{address}", coin.address)
    end
  end

  def get_progress_class(coin) do
    case get_percentage(coin) do
      nil -> ""
      value when value >= 100.0 ->
        "is-success"

      value when value <= 25.0 ->
        "is-danger"

      value when value >25 and value <=50 ->
        "is-warning"

      value when value >50 and value <=75  ->
        "is-link"

      value when value >75 and value <100 ->
        "is-primary"

      _ ->
        ""

    end
  end

  def get_total_usd(coins) do
    tot_usd =
      Enum.reduce(coins, 0, fn coin_info, acc ->
        case Map.get(coin_info, :price) do
          nil -> acc

          price ->  acc + (coin_info.balance * price)
        end
      end)

    Number.Currency.number_to_currency(tot_usd)
  end

  def get_price(coin) do
    case Map.get(coin, :price)  do
      nil -> "NA"
      price ->
          coin.balance * price
          |> Number.Currency.number_to_currency()
    end
  end
end
