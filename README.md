# Banana

Library to support connecting and interacting with Gru by a Minion.

## Installation

```elixir
def deps do
  [{:banana, "https://github.com/onboardingsystems/banana.git"}]
end
```

Add banana to your minion by adding it as a worker to your application supervisor.

```elixir
worker(Banana, [])
```

## Configuration

In your minion add the following configuration.

```elixir
# Used to configure the standard auth plug used by all minons.
config :banana, private_key: "pk_dev"

# Configure settings for minon to send information to Gru.
config :banana, :gru,
  host: "127.0.0.1",
  port: "3009",
  interval: 30_000

# Configure settings that Gru can use to pass requests onto the minon.
config :banana, :minion,
  name: "minion_name",
  host: "127.0.0.1",
  port: "3007"
```

## Minion API Authorization

Banana supports setting up a private key to secure minon content. Add the Auth Plug to your router.
If not configured, the default private key is `pk_dev`.

```elixir
pipeline :api do
  plug :accepts, ["json"]
  plug Banana.Web.Plugs.Auth
end
```