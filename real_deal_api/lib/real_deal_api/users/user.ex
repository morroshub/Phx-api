defmodule RealDealApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :full_name, :string
    field :gender, :string
    field :biography, :string
    belongs_to :account, RealDealApi.Accounts.Account #referencia de schema y la relacion de el objeto user y el objeto account.

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :full_name, :gender, :biography]) # añadimos AID
    |> validate_required([:account_id]) #Solo necesitamos AID para verificar
  end
end
