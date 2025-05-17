defmodule ChatAppWeb.AuthController do
  use ChatAppWeb, :controller
  alias ChatApp.Accounts
  alias ChatAppWeb.Auth.Guardian

  def login_page(conn, _params) do
    render(conn, :login)
  end

  def register_page(conn, _params) do
    render(conn, :register)
  end

  # Google認証のコールバック
  def google_callback(conn, %{"provider" => "google"} = params) do
    case Accounts.find_or_create_user_from_google(params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> json(%{token: token, user: user})

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end

  # ログイン処理
  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> json(%{token: token, user: user})

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "メールアドレスまたはパスワードが正しくありません"})
    end
  end

  # 登録処理
  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:created)
        |> json(%{token: token, user: user})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end 