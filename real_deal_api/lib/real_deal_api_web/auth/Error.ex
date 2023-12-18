defmodule RealDealApiWeb.Auth.ErrorResponse.Unathorized do
  defexception [message: "Error, Unauthorized", plug_status: 401]
end
