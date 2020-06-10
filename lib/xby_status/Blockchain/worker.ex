defmodule XbyStatus.Blockchain.Worker do
  alias XbyStatus.Blockchain.Fetch
  use GenServer

  @interval  4 * 60 * 1000 # every 4 minutes
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    contributions = Fetch.fetch_coin_contributions()
    update_contribution()
    {:ok, %{updated_at: DateTime.utc_now(), coins: contributions}}
  end

  def handle_call({:get_contribution}, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:fetch, _chains) do
    update_contribution()
    {:noreply, %{updated_at: DateTime.utc_now(), coins: Fetch.fetch_coin_contributions()}}
  end

  def fetch_contribution() do
    GenServer.call(__MODULE__, {:get_contribution})
  end

  defp update_contribution() do
    Process.send_after(self(), :fetch,  @interval)
  end

end
