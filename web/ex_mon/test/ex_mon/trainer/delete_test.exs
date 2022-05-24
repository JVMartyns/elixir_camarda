defmodule ExMon.Trainer.DeleteTest do
  use ExMon.DataCase

  alias ExMon.Trainer
  alias Trainer.Delete

  describe "call/1" do
    test "When the ID is valid, delete a trainer" do
      params = %{name: "Vitor", password: "123456"}
      ExMon.create_trainer(params)

      {:ok, %Trainer{id: id}} = ExMon.create_trainer(params)

      assert {:ok, _trainer} = Delete.call(id)
    end
  end
  test "When the ID is not valid, delete a trainer" do
    id = "invalid_ID"

    expected_response = {:error, "Invalid ID format!"}

    assert Delete.call(id) == expected_response
  end

  test "When the trainer not found" do
    id = Ecto.UUID.generate()

    expected_response = {:error, "Trainer not found"}

    assert Delete.call(id) == expected_response
  end
end
