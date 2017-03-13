defmodule Banana.Cache do
  @doc """
  Contacts Gru and stores a value in a shared cache amongst all Gru
  servers. Any minon will be able to retrieve the value back from Gru.
  """
  def set(key, value, ttl \\ nil) do
    gru_settings = Application.get_env :banana, :gru, []
    gru_host = Keyword.get gru_settings, :host, "127.0.0.1"
    gru_port = Keyword.get gru_settings, :port, "3009"

    minion_settings = Application.get_env :banana, :minion, []
    name = Keyword.get minion_settings, :name, "minion_set_name_in_config"

    key = "#{name}_#{key}"

    url = "http://#{gru_host}:#{gru_port}/cache"

    body = %{
      "key" => key,
      "value" => value,
      "ttl" => ttl
    }

    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    HTTPoison.post(url, Poison.encode!(body), headers)

    :ok
  end

  def get(key) do
    gru_settings = Application.get_env :banana, :gru, []
    gru_host = Keyword.get gru_settings, :host, "127.0.0.1"
    gru_port = Keyword.get gru_settings, :port, "3009"

    minion_settings = Application.get_env :banana, :minion, []
    name = Keyword.get minion_settings, :name, "minion_set_name_in_config"

    key = "#{name}_#{key}"

    url = "http://#{gru_host}:#{gru_port}/cache/#{key}"

    headers = [
      {"Accept", "application/json"}
    ]

    {:ok, %{body: body}} = HTTPoison.get(url, headers)
    Poison.decode!(body)["value"]
  end

  def delete(key) do
    gru_settings = Application.get_env :banana, :gru, []
    gru_host = Keyword.get gru_settings, :host, "127.0.0.1"
    gru_port = Keyword.get gru_settings, :port, "3009"

    minion_settings = Application.get_env :banana, :minion, []
    name = Keyword.get minion_settings, :name, "minion_set_name_in_config"

    key = "#{name}_#{key}"

    url = "http://#{gru_host}:#{gru_port}/cache/#{key}"

    headers = [
      {"Accept", "application/json"}
    ]

    HTTPoison.delete(url, headers)

    :ok
  end
end
