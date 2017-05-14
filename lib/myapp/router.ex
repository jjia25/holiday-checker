defmodule Myapp.Router do
  @moduledoc """
  Router for Myapp application
  """
  use Plug.Router

  plug :match
  plug :dispatch

  @doc """
  Start the Router
  """

  def start_link() do
    {:ok, _} = Plug.Adapters.Cowboy.http Myapp.Router, [], [port: 4000]
  end

  get "/hello" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "<h1>Hello</h1>")
  end
  forward "/", to: Myapp.HelloPlug
  match _ do
    conn
      |> send_resp(404, "Not found")
      |> halt
  end
end
