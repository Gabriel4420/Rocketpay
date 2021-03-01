#Interface para criação e inserção de dados na tabela Users
defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase

  alias Rocketpay.User
  alias Rocketpay.Users.Create
# Teste do Sucesso
  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Gabriel",
        password: "G@briel442018",
        nickname: "Gabriel4420",
        email: "gabriel@hotmail.com",
        age: 22
      }


      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Gabriel", age: 22, id: ^user_id} = user
    end

    # Teste da falha
    test "when there are invalid params , returns an error" do
      params = %{
        name: "Gabriel",
        nickname: "Gabriel4420",
        email: "gabriel@hotmail.com",
        age: 15
      }


      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
