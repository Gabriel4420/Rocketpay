defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Gabriel",
        password: "G@briel442018",
        nickname: "jhow",
        email: "gabriel@hotmail.com",
        age: 22
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic R2FicmllbDQ0MjA6R0BicmllbDQ0MjAxOA==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert%{
        "account" => %{
          "balance" => "50.00",
          "id" => _id
        },
        "message" => "Ballance changed successfully"
      } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response = expected_response
    end

    test "when all params are valid, make the withdraw", %{conn: conn, account_id: account_id} do

      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      assert%{
        "account" => %{
          "balance" => "50.00",
          "id" => _id
        },
        "message" => "Ballance changed successfully"
      } = response
    end

    test "when there are invalid params in withdraw, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response = expected_response
    end

  end
end
