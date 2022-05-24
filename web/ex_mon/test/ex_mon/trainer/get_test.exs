defmodule ExMon.Trainer.GetTest do
  use ExMon.DataCase

  alias ExMon.Trainer
  alias Trainer.Get

  describe "call/1" do
    test "When the ID is valid, return a trainer" do
      params = %{name: "Vitor", password: "123456"}
      ExMon.create_trainer(params)

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      assert {:ok, %Trainer{id: ^id}} = Get.call(id)
    end

    test "When the ID is not valid, delete a trainer" do
      id = "invalid_ID"

      expected_response = {:error, "Invalid ID format!"}

      assert Get.call(id) == expected_response
    end

    test "When the trainer not found" do
      id = Ecto.UUID.generate()

      expected_response = {:error, "Trainer not found"}

      assert Get.call(id) == expected_response
    end
  end
end
