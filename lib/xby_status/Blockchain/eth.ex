defmodule XbyStatus.Blockchain.Eth do
  alias __MODULE__, as: Eth

  defstruct [
    :address,
    icon: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Ethereum-icon-purple.svg/1200px-Ethereum-icon-purple.svg.png",
    goal: nil,
    balance: nil,
    name: "Ethereum",
    tx_lookup_url: "https://etherscan.io/address/{address}",
    api_key: nil,
    symbol: "ETH"
  ]

  def new() do
    eth_configs = Application.get_env(:xby_status, :eth)
    struct(__MODULE__, eth_configs)
  end
end

defimpl XbyStatus.Blockchain, for: XbyStatus.Blockchain.Eth  do
  alias XbyStatus.Blockchain.Eth
  alias XbyStatus.Blockchain.Utils

  def fetch_balance(%Eth{address: eth_addr, api_key: api_key} = eth) when is_binary(eth_addr) and is_binary(api_key) do
    url = "https://api.etherscan.io/api?module=account&action=balance&address=#{eth_addr}&tag=latest&apikey=#{api_key}"

    balance =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          Jason.decode!(body)
          |> Map.get("result")
          |> Utils.wei_to_eth()

        _ ->
          nil
    end

    Map.put(eth, :balance, balance)
  end
end
