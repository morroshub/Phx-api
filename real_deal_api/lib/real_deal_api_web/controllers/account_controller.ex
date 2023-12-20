defmodule RealDealApiWeb.AccountController do
  use RealDealApiWeb, :controller

  alias RealDealApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}

  plug :is_authorized_account when action in [:update, :delete]

  action_fallback RealDealApiWeb.FallbackController

  defp is_authorized_account(conn, _opts) do # permite extraer un objeto del tipo "account" de la solicitud web (conn) | le damos entidad privada a cada cuenta para que no se pueda actualizar desde fuera los datos.
    %{params: %{"account" => params}} = conn
    account = Account.get_account!(params["id"])
    if conn.assigns.account.id == account.id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end


  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(account), # Se utiliza Guardian para generar un token de autenticación
          {:ok, %User{} = user} <- User.create_user(account, account_params) do #Creaa un usuario asociado a la cuenta creada anteriormente
      conn
      |> put_status(:created)
      |> render("account_token.json", %{account: account, token: token})
    end
  end


  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
     case Guardian.authenticate(email, hash_password) do # tomamos de la funcion guardian.auth y creamos un condicional en el caso de que sea correcto o incorrecto para hacer el sign in.
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id ) #  se utiliza para almacenar información en la sesión del usuario
        |> put_status(:ok)
        |> render("account_token.json", %{account: account, token: token})
      {:error, :unauthorized} -> raise ErrorResponse.Unathorized, message: "Error, Email or Password are incorrect, try again"
     end
  end

  def refresh_session(conn, %{}) do
    old_token = Guardian.Plug.current_token(conn)
    case Guardian.decode_and_verify(old_token) do
      {:ok, claims} ->
        case Guardian.resource_from_claims(claims) do
          {:ok, account} ->
            {:ok, _oldtoken, {new_token, _new_claims}} = Guardian.resfresh(old_token)
            conn
            |> Plug.Conn.put_session(:account_id, account.id)
            |> put_status(:ok)
            |> render("account_token.json", %{account: account, token: new_token})

          {:error, _reason} ->
            raise ErrorResponse.NotFound
        end

      {:error, _reason} ->
        raise ErrorResponse.NotFound
    end
  end

  def sign_out(conn, %{}) do
    account =conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)
    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render("account_token.json", %{account: account, token: nil})
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def update(conn, %{ "account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
