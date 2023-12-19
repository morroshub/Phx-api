defmodule RealDealApiWeb.Auth.SetAccount do
  import Plug.Conn
  alias RealDealApiWeb.Auth.ErrorResponse
  alias RealDealApi.Accounts

  def init(_options) do

  end

  def call(conn, _options) do # Tomamos y reconvertimos con uno nuevo
    if conn.assigns[:account] do #check si tenemos la cuenta en la db
      conn
    else # De no tenerla tratamos de recuperarla y servirla
      account_id = get_session(conn, :account_id) #id de cuenta a iniciar

      if account_id == nil, do: raise ErrorResponse.Unauthorized # Manejo de error en el caso de no estar cumpliendo la autorizacion

      account = Accounts.get_account!(account_id)
      cond do # Nos entrega el id de cuenta
        account_id && account -> assign(conn, :account, account)
        true -> assign(conn, :account, nil)
      end
    end
  end
end
