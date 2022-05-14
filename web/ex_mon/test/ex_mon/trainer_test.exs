defmodule ExMon.TrainerTest do
  use ExMon.DataCase

  alias ExMon.Trainer

  describe "changeset/1" do
    test "when all params are valid, return a valid changeset" do
      params = %{name: "Vitor", password: "123456"}

      response = Trainer.changeset(params)

      assert %Ecto.Changeset{
               action: nil,
               changes: %{
                 name: "Vitor",
                 password: "123456",
                 password_hash: _password_hash
               },
               errors: [],
               data: %ExMon.Trainer{},
               valid?: true
             } = response
    end

    test "when all params are invalid, return a invalid changeset" do
      params = %{password: "123456"}

      response = Trainer.changeset(params)

      assert %Ecto.Changeset{
               action: nil,
               changes: %{password: "123456"},
               errors: [name: {"can't be blank", [validation: :required]}],
               data: %ExMon.Trainer{},
               valid?: false
             } = response

      assert errors_on(response) == %{name: ["can't be blank"]}
    end
  end

  describe "build/1" do
    test "when all params are valid return a trainer struct" do
      params = %{name: "Vitor", password: "123456"}

      response = Trainer.build(params)

      assert {:ok, %Trainer{name: "Vitor", password: "123456"}} = response
    end

    test "when all params are invalid returns a error" do
      params = %{password: "123456"}

      assert {:error, response} = Trainer.build(params)
      assert %Ecto.Changeset{valid?: false} = response
      assert errors_on(response) == %{name: ["can't be blank"]}
    end
  end
end
