defmodule RealDealApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias RealDealApi.Repo

  alias RealDealApi.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)


  # Funcion agregada | Traemos todos los datos de la cuenta con la id de la misma | Pipe preload

  def get_full_account(id) do
    Account
    |> where(id: ^id) # Este es un método de consulta de Ecto ^id se remplazará con el valor real de la variable id
    |> preload([:user]) #Esto es útil para evitar la necesidad de realizar una consulta adicional cuando se accede al campo :user.
    |>Repo.one()
  end

  @doc """
  Gets a single account.any()

  Returns 'nil' if the Account does not exist.

  ## Examples

    iex > get_account_by_email(test@email.com)
    %Account{}

    iex> get_account_by_email(no_account@email.com)
    nil
  """

  def get_account_by_email(email) do
    Account
    |> where(email: ^email)
    |> Repo.one()
  end


  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end
