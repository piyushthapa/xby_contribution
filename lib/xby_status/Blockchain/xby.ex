defmodule XbyStatus.Blockchain.Xby do
  defstruct [
    :address,
    icon: "https://logos-download.com/wp-content/uploads/2019/11/XtraBYtes_XBY_Logo_blue-700x608.png",
    goal: 2_000_000,
    balance: nil,
    name: "XTRABYTES",
    tx_lookup_url: "https://xtrabytes.global/explorer/xby?open=%2Faddress%2Fxby%2F{address}",
    api_key: nil,
    symbol: "XBY"
  ]

  def new() do
    struct(__MODULE__, Application.get_env(:xby_status, :xby))
  end
end

defimpl XbyStatus.Blockchain, for: XbyStatus.Blockchain.Xby  do
  alias XbyStatus.Blockchain.Xby
  alias XbyStatus.Blockchain.Xby.Parser

  def fetch_balance(%Xby{address: xby_address} = xby) when is_binary(xby_address) do
    url = "https://xtrabytes.global/explorer/xby/search?searchCriteria=#{xby_address}"
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

defmodule XbyStatus.Blockchain.Xby.Parser do
  import Excrawl

  parser :parse do
    text name: :balance, css: ".info-modal-stripe-xby .amountinteger:first-child, .info-modal-stripe-xfuel .amountinteger:first-child "
  end
end

