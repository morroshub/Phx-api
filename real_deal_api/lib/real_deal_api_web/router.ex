defmodule RealDealApiWeb.Router do
  use RealDealApiWeb, :router
  use Plug.ErrorHandler #Este módulo proporciona una serie de funciones y convenios para manejar errores en la aplicación




  # Esta función se encarga de manejar los errores del tipo Phoenix.Router.NoRouteError. Este error ocurre cuando no se encuentra una ruta que coincida con la solicitud del cliente. ->

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do

    conn |> json(%{errors: message}) |> halt()
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do

    conn |> json(%{errors: message}) |> halt()
  end


  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session # La información de la sesión se almacena en una cookie cifrada perpetuamos la session
  end


  pipeline :auth do
    plug RealDealApiWeb.Auth.Pipeline
    plug RealDealApiWeb.Auth.SetAccount
  end

  scope "/api", RealDealApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

#Endpoints protegidos por Guardian/JWT
  # Requisito de JWT para nuestros endpoints desde las api
  scope "/api", RealDealApiWeb do # agrupamos y org rutas que comparten un prefijo común "/api" en este caso
    pipe_through [:api, :auth]
    get "/accounts/by_id/:id", AccountController, :show
    get "/accounts/sign_out", AccountController, :sign_out
    post "/accounts/update", AccountController, :update

  end

end
