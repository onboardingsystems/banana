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
config :banana, :gru,
  host: "127.0.0.1",
  port: "3009",
  interval: 30_000

config :banana, :minion,
  name: "minion_name",
  host: "127.0.0.1",
  port: "3007"
```
