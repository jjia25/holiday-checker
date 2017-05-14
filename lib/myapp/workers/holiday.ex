defmodule Myapp.Workers.Holiday do
  use GenServer
  require Poison
  require HTTPoison

  def lookup_holiday(country \\ "US") do
    GenServer.call(__MODULE__, {:lookup, country})
  end

  def int(state), do: {:ok, state}
  def start_link(), do: start_link([], [])
  def start_link(_type, state) do
    {:ok, __pid} = GenServer.start(Myapp.Workers.Holiday, [],
    name: __MODULE__)
  end
  def handle_call({:lookup, country}, _from, state) do
    IO.puts "Handling call in GenServer"
    {:ok, body} = handle_api_call(country)
    {:reply, body, state}
  end
  def handle_call(msg, _from, state) do
    {:reply, [], state}
  end
  def handle_cast(msg, state) do
    {:noreply, state}
  end

  defp handle_api_call(country) do
    case get_request(country) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, process_body(body)}
      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, "Error"}
      {:error, _} ->
        {:error, "error"}
    end
  end
  defp process_body(body), do: body |> Poison.decode!
  defp get_request(country) do
    key = Application.get_env(:myapp, :holiday)[:key]
    url = get_url()
    query_params = %{"key" => key, "country" => country, "year" => "2017"}
    HTTPoison.get(url, [], [params: query_params])
  end

  defp get_url() do
    "https://holidayapi.com/v1/holidays"
  end
end
