defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    has_one :user, RealDealApi.Users.User # Creamos una relacion 1:1 entre account y user

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password]) # requisitos obligatorios de la funcion
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/ , message: "Debe tener @ sin espacios")
    |> validate_length(:email, max: 150) #verifica la longitud del campo asignando un maximo
    |> unique_constraint(:email) #verifica dato unico
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset) do
  change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))

  defp put_password_hash(changeset), do: changeset
  end

end
