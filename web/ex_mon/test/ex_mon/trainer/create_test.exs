defmodule ExMon.Trainer.CreateTest do
  use ExMon.DataCase

  alias ExMon.{Repo, Trainer}
  alias Trainer.Create

  describe "call/1" do
    test "when all params are valid, create a trainer" do
      params = %{name: "Vitor", password: "123456"}

      count_before = Repo.aggregate(Trainer, :count)

      response = Create.call(params)

      count_after = Repo.aggregate(Trainer, :count)

      assert {:ok, %Trainer{name: "Vitor"}} = response
      assert count_after > count_before
    end

    test "when there are invalid params, return the error" do
      params = %{name: "Vitor"}

      assert {:error, changeset} = Create.call(params)
      assert errors_on(changeset) == %{password: ["can't be blank"]}
    end
  end
end
