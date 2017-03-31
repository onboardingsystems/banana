defmodule Banana.Webhook do
  def send(url, message, content_type \\ "application/json") do
    gru_settings = Application.get_env :banana, :gru, []
    gru_host = Keyword.get gru_settings, :host, "127.0.0.1"
    gru_port = Keyword.get gru_settings, :port, "3009"

    gru_url = "http://#{gru_host}:#{gru_port}/webhook"
    minion_settings = Application.get_env :banana, :minion, []
    minion_name = Keyword.get minion_settings, :name, "minion_set_name_in_config"

    body = %{
      "minion" => minion_name,
      "url" => url,
      "content_type" => content_type,
      "message" => Poison.encode!(message)
    }

    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    HTTPoison.post(gru_url, Poison.encode!(body), headers)
  end
end
