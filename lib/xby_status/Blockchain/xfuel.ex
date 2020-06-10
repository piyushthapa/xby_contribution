defmodule XbyStatus.Blockchain.Xfuel do
  defstruct [
    :address,
    icon: "https://xtrabytes.global/build/images/xfuel/logo.png",
    goal: 2_000_000,
    balance: nil,
    name: "Xfuel",
    tx_lookup_url: "https://xtrabytes.global/explorer/xfuel",
    symbol: "XFUEL"
  ]

  def new() do
    struct(__MODULE__, Application.get_env(:xby_status, :xfuel))
  end
end


defimpl XbyStatus.Blockchain, for: XbyStatus.Blockchain.Xfuel  do
  alias XbyStatus.Blockchain.Xfuel
  alias XbyStatus.Blockchain.Xby.Parser

  def fetch_balance(%Xfuel{address: xfuel_addr} = xby) when is_binary(xfuel_addr) do
    url = "https://xtrabytes.global/explorer/xfuel/search?searchCriteria=#{xfuel_addr}"
    balance =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body
          |> Parser.parse()
          |> extract_balance()

        _ ->
          %{balance: nil}
      end

    Map.put(xby, :balance, balance)

  end

  defp extract_balance(%{balance: balance}) when is_binary(balance) do
    balance
    |> String.replace(".", "")
    |> String.replace(",", "")
    |> XbyStatus.Blockchain.Utils.to_float()
  end

  defp extract_balance(_), do: nil
end
