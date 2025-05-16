defmodule ChatAppWeb.PageController do
  use ChatAppWeb, :controller

  def home(conn, _params) do
    # ランダムなユーザー名を生成
    user_id = "user_#{:rand.uniform(1000)}"
    render(conn, :home, user_id: user_id)
  end
end
