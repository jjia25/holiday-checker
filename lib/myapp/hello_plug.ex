defmodule Myapp.HelloPlug do
  @moduledoc """
  """
  import Plug.Conn
  def init([]), do: false
  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "<h1>Hello from the plug </h1>")
  end
end
