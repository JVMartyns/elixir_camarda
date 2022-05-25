defmodule ExMonWeb.WelcomeControllerTest do
  use ExMonWeb.ConnCase

  describe "show/2" do
    test "show welcome message" do
      conn = get(build_conn(), "/")
      assert conn.resp_body =~ "Welcome to the ExMon API!"
    end
  end
end
