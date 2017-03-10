defmodule Banana.Webhook do
  def send(url, message, content_type \\ "application/json") do
    gru_settings = Application.get_env :banana, :gru, []
    gru_host = Keyword.get gru_settings, :host, "127.0.0.1"
    gru_port = Keyword.get gru_settings, :port, "3009"

    url = "http://#{gru_host}:#{gru_port}/cache"

    body = %{
      "url" => url,
      "content_type" => content_type,
      "message" => message
    }

    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    HTTPoison.post(url, Poison.encode!(body), headers)
  end
end
