# Setaria

Setaria is OATH One Time Passwords Library for Elixir.
This is wrapper of [POT](https://hex.pm/packages/pot).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `setaria` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:setaria, "~> 0.1.0"}]
    end
    ```

  2. Ensure `setaria` is started before your application:

    ```elixir
    def application do
      [applications: [:setaria]]
    end
    ```
