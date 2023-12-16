defmodule RealDealApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :hash_password, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:email]) # Nos permite interacturar con la db y el valor marcado, se usa email por que solo puede haber uno por cuenta.
  end
end
