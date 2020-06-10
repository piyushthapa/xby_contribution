defmodule XbyStatus.Blockchain.Worker do
  alias XbyStatus.Blockchain.Fetch
  use GenServer

  @interval 300_000 # every 5 minutes
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    contributions = Fetch.fetch_coin_contributions()
    Process.send_after(self(), :fetch, @interval)
    {:ok, %{updated_at: DateTime.utc_now(), coins: contributions}}
  end

  def handle_call({:get_contribution}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:fetch, _chains) do
    Process.send_after(self(), :fetch, @interval)
    {:noreply, %{updated_at: DateTime.utc_now(), coins: Fetch.fetch_coin_contributions()}}
  end

  def fetch_contribution() do
    GenServer.call(__MODULE__, {:get_contribution})
  end

  def update_contribution() do
    GenServer.cast(__MODULE__, :fetch)
  end

end
