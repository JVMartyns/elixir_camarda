defmodule ExMonWeb.TrainerPokemonsControllerTest do
  use ExMonWeb.ConnCase

  import Tesla.Mock

  alias ExMonWeb.Auth.Guardian

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "create/2" do
    setup %{conn: conn} do
      params = %{name: "Vitor", password: "123456"}
      {:ok, trainer} = ExMon.create_trainer(params)
      {:ok, token, _claims} = Guardian.encode_and_sign(trainer)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, trainer_id: trainer.id}
    end

    test "when all params are valid, insert the pokemon on DB.", %{
      conn: conn,
      trainer_id: trainer_id
    } do
      # ---------------------------Mock---------------------------------
      body = %{
        "id" => 25,
        "name" => "pikachu",
        "weight" => 60,
        "types" => [
          %{
            "type" => %{"name" => "eletric"}
          }
        ]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      # ----------------------------------------------------------------

      params = %{
        "name" => "pikachu",
        "nickname" => "foguinho",
        "trainer_id" => trainer_id
      }

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "Pokemon created!",
               "pokemon" => %{
                 "id" => _pokemon_id,
                 "inserted_at" => _inserted_at,
                 "name" => "pikachu",
                 "nickname" => "foguinho",
                 "trainer_id" => ^trainer_id,
                 "types" => ["eletric"],
                 "weight" => 60
               }
             } = response
    end

    test "when pokemon doesn't exist", %{conn: conn, trainer_id: trainer_id} do
      # ---------------------------Mock---------------------------------
      mock(fn %{method: :get, url: @base_url <> "banana"} ->
        %Tesla.Env{status: 404}
      end)

      # ----------------------------------------------------------------

      params = %{
        "name" => "banana",
        "nickname" => "foguinho",
        "trainer_id" => trainer_id
      }

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, params))
        |> json_response(404)

      assert response == %{"message" => "Pokemon not found!"}
    end

    # test "when trainer doesn't exist", %{conn: conn} do
    #   # ---------------------------Mock---------------------------------
    #   body = %{
    #     "id" => 25,
    #     "name" => "pikachu",
    #     "weight" => 60,
    #     "types" => [
    #       %{
    #         "type" => %{"name" => "eletric"}
    #       }
    #     ]
    #   }

    #   mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
    #     %Tesla.Env{status: 200, body: body}
    #   end)

    #   # ----------------------------------------------------------------
    #   params = %{
    #     "name" => "pikachu",
    #     "nickname" => "foguinho",
    #     "trainer_id" => Ecto.UUID.generate()
    #   }

    #   response =
    #     conn
    #     |> post(Routes.trainer_pokemons_path(conn, :create, params))
    #     |> json_response(404)

    #   assert response == %{"message" => "Trainer not found"}
    # end
  end
end
