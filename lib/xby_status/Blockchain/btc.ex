defmodule XbyStatus.Blockchain.Btc do

  defstruct [
    :address,
    icon: "https://ih1.redbubble.net/image.485310424.3984/ap,550x550,12x12,1,transparent,t.u1.png",
    goal: 5,
    balance: nil,
    name: "Bitcoin",
    tx_lookup_url: "https://www.blockchain.com/btc/address/{address}",
    symbol: "BTC"
  ]

  def new() do
    struct(__MODULE__, Application.get_env(:xby_status, :btc))
  end
end

defimpl XbyStatus.Blockchain, for: XbyStatus.Blockchain.Btc  do
  alias XbyStatus.Blockchain.Btc

  def fetch_balance(%Btc{address: addr} = btc) when is_binary(addr) do
    url = "https://blockchain.info/q/addressbalance/#{addr}"
    balance =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          XbyStatus.Blockchain.Utils.sat_to_btc(body)

        _ ->
          nil
      end

    Map.put(btc, :balance, balance)
  end

end
