defmodule Banana do
  @moduledoc """
  Provides utilities for connecting a Minion with Gru.
  Will register the local minion with Gru.
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    send(self(), :tick)
    {:ok, state}
  end

  def handle_info(:tick, state) do
    schedule_tick()
    work()
    {:noreply, state}
  end

  defp work() do
    register()
  end

  defp schedule_tick() do
    gru_settings = Application.get_env :banana, :gru
    interval = Keyword.get gru_settings, :register_interval, 30_000

    Process.send_after(self(), :tick, interval)
  end


  def register do
    gru_settings = Application.get_env :banana, :gru, []
    gru_host = Keyword.get gru_settings, :host, "http://localhost"
    gru_port = Keyword.get gru_settings, :port, "3009"

    minion_settings = Application.get_env :banana, :minion, []
    name = Keyword.get minion_settings, :name, "minion_set_name_in_config"
    host = Keyword.get minion_settings, :host, "http://localhost"
    port = Keyword.get minion_settings, :port, "3007"

    url = "#{gru_host}:#{gru_port}/ping"
    body = Poison.encode!(%{
      "minion_key" => name,
      "host" => host,
      "port" => port
    })
    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]
    HTTPoison.post(url, body, headers)
  end
end
