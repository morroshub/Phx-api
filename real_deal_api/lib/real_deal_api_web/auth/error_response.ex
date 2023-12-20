defmodule RealDealApiWeb.Auth.ErrorResponse.Unathorized do
  defexception [message: "Error, Unauthorized", plug_status: 401]
end

defmodule RealDealApiWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "Error : User no authorized.", plug_status: 403]
end

defmodule RealDealApiWeb.Auth.ErrorResponse.NotFound do
  defexception [message: "Not Found", plug_status: 404]
end
