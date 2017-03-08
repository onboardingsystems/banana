defmodule Banana.Web.Plugs.Auth do
  @moduledoc """
  Provides common configurable minion authorization support.
  """
  import Plug.Conn

  def init(opts), do: opts
  
  def call(conn, _opts) do
    if authorize get_req_header(conn, "authorization") do
      conn
    else
      forbidden conn
    end
  end

  defp forbidden(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(403, "{\"errors\":\"Access Forbidden\"}")
    |> halt
  end

  defp authorize(["Basic " <> credentials | _any_other_entries]) do
    key =
      credentials
      |> Base.decode64!
      |> String.replace(":", "")

    key == Application.get_env(:banana, :private_key, "pk_dev")
  catch
    _ -> false
  rescue
    _ -> false
  end
  defp authorize(_), do: nil
end