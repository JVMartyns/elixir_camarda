defmodule ExMonWeb.PokemonsControllerTest do
  use ExMonWeb.ConnCase

  import Tesla.Mock

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "show/2" do
    setup do
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

      :ok
    end

    test "search and show pokemon", %{conn: conn} do
      response =
        conn
        |> get(Routes.pokemons_path(conn, :show, "pikachu"))
        |> json_response(200)

      assert response == %{
               "id" => 25,
               "name" => "pikachu",
               "types" => ["eletric"],
               "weight" => 60
             }
    end
  end
end
