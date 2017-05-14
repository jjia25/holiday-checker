defmodule Myapp do
  @moduledoc """
  Documentation for Myapp.
  """

  use Application

  @doc """
  Start function for Myapp application
  """
  def start(_type, _args) do
  import Supervisor.Spec, warn: false

  children = [
    worker(Myapp.Router, []),
    worker(Myapp.Workers.Holiday, [])
  ]

  opts = [
    strategy: :one_for_one, name: Myapp.Supervisor
  ]

  Supervisor.start_link(children, opts)
  end
end
