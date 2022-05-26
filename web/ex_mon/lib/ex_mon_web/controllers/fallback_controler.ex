defmodule ExMonWeb.FallbackController do
  use ExMonWeb, :controller

  def call(conn, {:error, message, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExMonWeb.ErrorView)
    |> render("404.json", message: message)
  end

  def call(conn, {:error, "Trainer not found" = message}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExMonWeb.ErrorView)
    |> render("404.json", message: message)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ExMonWeb.ErrorView)
    |> render("401.json", message: "Trainer unauthorized")
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
