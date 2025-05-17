defmodule ChatApp.Accounts do
  import Ecto.Query, warn: false
  alias ChatApp.Repo
  alias ChatApp.Accounts.User

  def find_or_create_user_from_google(%{"ueberauth_auth" => auth}) do
    email = auth.info.email
    name = auth.info.name

    case Repo.get_by(User, email: email) do
      nil ->
        %User{}
        |> User.changeset(%{email: email, name: name, provider: "google"})
        |> Repo.insert()
      user ->
        {:ok, user}
    end
  end

  def find_or_create_user_from_google(_), do: {:error, "Google認証情報が取得できません"}

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)
    if user do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end 