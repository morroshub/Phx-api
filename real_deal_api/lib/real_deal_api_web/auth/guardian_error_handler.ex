defmodule RealDealApiWeb.Auth.GuardianErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opt) do
    body = Jason.encode!(%{error: to_string(type)}) # transformamos el type de la respuesta.
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
