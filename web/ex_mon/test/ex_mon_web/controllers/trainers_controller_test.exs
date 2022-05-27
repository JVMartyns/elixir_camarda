defmodule ExMonWeb.TrainersControllerTest do
  use ExMonWeb.ConnCase
  import ExMonWeb.Auth.Guardian

  alias ExMon.Trainer

  describe "show/2" do
    setup %{conn: conn} do
      params = %{name: "Vitor", password: "123456"}
      {:ok, trainer} = ExMon.create_trainer(params)
      {:ok, token, _claims} = encode_and_sign(trainer)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

    test "when there is a trainer with the given id, returns the trainer", %{conn: conn} do
      params = %{name: "Vitor", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      response =
        conn
        |> get(Routes.trainers_path(conn, :show, id))
        |> json_response(:ok)

      assert %{"id" => _id, "inserted_at" => _inserted_at, "name" => "Vitor"} = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "12345"))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid ID format!"}

      assert expected_response == response
    end
  end

  describe("create/2") do
    test "when all params are valid, create a trainer", %{conn: conn} do
      params = %{"name" => "Vitor", "password" => "123456"}

      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(201)

      assert %{
               "message" => "Trainer created!",
               "token" => _token,
               "trainer" => %{
                 "id" => _id,
                 "inserted_at" => _inserted_at,
                 "name" => "Vitor"
               }
             } = response
    end

    test "when password is blank, return an error", %{conn: conn} do
      params = %{"name" => "Vitor", "password" => ""}

      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(400)

      assert response == %{"message" => %{"password" => ["can't be blank"]}}
    end

    test "when one of the fields is empty, return an error", %{conn: conn} do
      params = %{"name" => "", "password" => "123456"}

      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(400)

      assert response == %{"message" => %{"name" => ["can't be blank"]}}
    end
  end

  describe "sign_in/2" do
    setup do
      params = %{"name" => "Vitor", "password" => "123456"}
      {:ok, %Trainer{id: id, password: password}} = ExMon.create_trainer(params)
      params = %{"id" => id, "password" => password}

      {:ok, params: params}
    end

    test "When all params are valid, retorn a token", %{conn: conn, params: params} do
      response =
        conn
        |> post(Routes.trainers_path(conn, :sign_in, params))
        |> json_response(200)

      assert %{"token" => _token} = response
    end

    test "When password is invalid, retorn unalthorized", %{conn: conn, params: params} do
      params = %{"id" => params["id"], "password" => "12345"}

      response =
        conn
        |> post(Routes.trainers_path(conn, :sign_in, params))
        |> json_response(401)

      assert response == %{"message" => "Trainer unauthorized"}
    end

    test "When the trainer is invalid, retorn an error", %{conn: conn} do
      params = %{"id" => Ecto.UUID.generate(), "password" => "123456"}

      response =
        conn
        |> post(Routes.trainers_path(conn, :sign_in, params))
        |> json_response(404)

      assert response == %{"message" => "Trainer not found"}
    end
  end

  describe "delete/2" do
    test "when the trainer ID is valid, delete a trainer", %{conn: conn} do
      params = %{"name" => "Vitor", "password" => "123456"}
      {:ok, %Trainer{id: trainer_id} = trainer} = ExMon.create_trainer(params)

      {:ok, token, _claims} = ExMonWeb.Auth.Guardian.encode_and_sign(trainer)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> delete(Routes.trainers_path(conn, :delete, trainer_id))
        |> text_response(204)

      assert response == ""
    end

    test "when the trainer ID is valid but doesn't have a valid token", %{conn: conn} do
      params = %{"name" => "Vitor", "password" => "123456"}
      {:ok, %Trainer{id: trainer_id}} = ExMon.create_trainer(params)

      response =
        conn
        |> put_resp_content_type("application/json")
        |> delete(Routes.trainers_path(conn, :delete, trainer_id))
        |> json_response(401)

      assert response == %{"message" => "unauthenticated"}
    end
  end

  describe "update" do
    test "when all params is valid, update a traioner", %{conn: conn} do
      params = %{"name" => "Vitor", "password" => "123456"}
      {:ok, %Trainer{id: trainer_id} = trainer} = ExMon.create_trainer(params)

      {:ok, token, _claims} = ExMonWeb.Auth.Guardian.encode_and_sign(trainer)

      new_params = %{"name" => "Vitor", "password" => "123456"}

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put(Routes.trainers_path(conn, :update, trainer_id, new_params))
        |> json_response(200)

      assert %{
               "message" => "Trainer updated!",
               "trainer" => %{
                 "id" => ^trainer_id,
                 "inserted_at" => _inserted_at,
                 "name" => "Vitor",
                 "updated_at" => _updated_at
               }
             } = response
    end

    test "when the trainer ID is valid but doesn't have a valid token, return unalthorized", %{
      conn: conn
    } do
      params = %{"name" => "Vitor", "password" => "123456"}
      {:ok, %Trainer{id: trainer_id}} = ExMon.create_trainer(params)

      new_params = %{"name" => "Vitor", "password" => "123456"}

      response =
        conn
        |> put_resp_content_type("application/json")
        |> put(Routes.trainers_path(conn, :update, trainer_id, new_params))
        |> json_response(401)

      assert response == %{"message" => "unauthenticated"}
    end
  end
end
