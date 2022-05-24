defmodule ExMon.Trainer.UpdateTest do
  use ExMon.DataCase

  alias ExMon.Trainer
  alias Trainer.Update

  describe "call/1" do
    test "whe the params are valid, update a trainer" do
      params = %{name: "Vitor", password: "123456"}
      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      new_params = %{"id" => id, "name" => "Potato", "password" => "123456"}

      response = Update.call(new_params)

      assert {:ok, %Trainer{name: "Potato"}} = response
    end

    test "When the ID is not valid, delete a trainer" do
      params = %{"id" => "invalid_ID", "name" => "Potato", "password" => "123456"}

      expected_response = {:error, "Invalid ID format!"}

      assert Update.call(params) == expected_response
    end

    test "When the trainer not found" do
      id = Ecto.UUID.generate()
      params = %{"id" => id, "name" => "Potato", "password" => "123456"}

      expected_response = {:error, "Trainer not found"}

      assert Update.call(params) == expected_response
    end
  end
end
