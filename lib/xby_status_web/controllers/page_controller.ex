defmodule XbyStatusWeb.PageController do
  use XbyStatusWeb, :controller
  alias XbyStatus.Blockchain.Worker
  def index(conn, _params) do

    render(conn, "index.html", contributions: Worker.fetch_contribution())
  end
end
