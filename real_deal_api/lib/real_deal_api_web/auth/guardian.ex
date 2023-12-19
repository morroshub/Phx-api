defmodule RealDealApiWeb.Auth.Guardian do
  use Guardian, otp_app: :real_deal_api
  alias RealDealApi.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do
      nil -> {:error, :account_notexist_or_account_not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    with account <- Accounts.get_account_by_email(email),
    true <- validate_password(password, account.hash_password),
    {:ok, token, _claims} <- encode_and_sign(account) do
 {:ok, account, token}
else
 nil -> {:error, :account_not_found}
 false -> {:error, :invalid_password}
 _ -> {:error, :unauthorized}
end

  defp validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  defp create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account)
    {:ok, account, token}
  end

end
