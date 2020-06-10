defmodule XbyStatus.Blockchain.Fetch do
  alias XbyStatus.Blockchain.Btc
  alias XbyStatus.Blockchain.Eth
  alias XbyStatus.Blockchain.Xby
  alias XbyStatus.Blockchain.Xfuel


  @coins [Btc, Eth, Xby, Xfuel]
  @timeout 5 * 60 * 1000 # 5 minutes

  def fetch_coin_contributions() do
    @coins
    |> Enum.map(&fetch_async/1)
    |> Enum.map(&fetch_await/1)
  end

  defp fetch_async(coin) do
    Task.async(fn ->
      coin.new()
      |> XbyStatus.Blockchain.fetch_balance()
    end)
  end

  defp fetch_await(task) do
    Task.await(task, @timeout)
  end
end
