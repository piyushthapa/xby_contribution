defprotocol XbyStatus.Blockchain do
  def fetch_balance(coin)
  def fetch_price(coin)
end

