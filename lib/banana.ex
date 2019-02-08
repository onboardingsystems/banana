defmodule Banana do
  @moduledoc """
  Provides utilities for connecting a Minion with Gru.
  Will register the local minion with Gru.
  """
  use GenServer
  require Logger

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
    case HTTPoison.post(url, body, headers) do
      {:ok, %{status_code: code}} = success when code in 200..299 ->
        Logger.debug("Banana: Registered with Gru(#{url}): #{inspect body}")
        success
      {:ok, error} ->
        Logger.error("Banana: Failed to register with Gru(#{url}): #{inspect body}: #{inspect error}")
        {:ok, error}
      {:error, error}->
        Logger.error("Banana: Failed to register with Gru(#{url}): #{inspect error}")
        {:error, error}
    end
  end
end
