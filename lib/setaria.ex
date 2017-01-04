defmodule Setaria do
  @moduledoc """

  ## Setaria

  Setaria is OATH One Time Passwords Library for Elixir.  
  This is wrapper of [POT](https://hex.pm/packages/pot).

  NOTE: Some parameters are fixed now. The timestep is 30, digits is 6, and digest method is sha.
  """

  @default_timestep 30

  # hotp creation
  @doc """
  Create HOTP with secret and counter

  * opts
   * `encoded_secret: false` : secret is not base32 encoded.
  """
  @spec hotp(secret :: String.t, counter :: Integer.t, opts :: Keyword.t) :: String.t
  def hotp(secret, counter, opts \\ []) do
    encoded_secret = get_encoded_secret(secret, opts)
    :pot.hotp(encoded_secret, counter)
  end

  # hotp validation
  @doc """
  Validate HOTP with secret and counter.

  * opts
   * `encoded_secret: false` : secret is not base32 encoded.
  """
  @spec valid_hotp(token :: String.t, secret :: String.t, counter :: Integer.t, opts :: Keyword.t) :: boolean
  def valid_hotp(token, secret, counter, opts \\ []) do
    encoded_secret = get_encoded_secret(secret, opts)
    :pot.valid_hotp(token, encoded_secret, [{:last, counter - 1}]) == counter
  end

  # totp creation
  @doc """
  Create TOTP with secret.

  * opts
   * `encoded_secret: false` : secret is not base32 encoded.
   * `timestamp` : timestamp
  """
  @spec totp(secret :: String.t, opts :: Keyword.t) :: String.t
  def totp(secret, opts \\ []) do
    encoded_secret = get_encoded_secret(secret, opts)
    timestamp = get_timestamp(opts)
    counter = get_counter_from_timestamp(timestamp)
    hotp(encoded_secret, counter)
  end

  # totp validation
  @doc """
  Validate TOTP with secret.

  * opts
   * `encoded_secret: false` : secret is not base32 encoded.
   * `timestamp` : timestamp, default is current timestamp
  """
  @spec valid_totp(token :: String.t, secret :: String.t, opts :: Keyword.t) :: boolean
  def valid_totp(token, secret, opts \\ []) do
    encoded_secret = get_encoded_secret(secret, opts)
    timestamp = get_timestamp(opts)
    counter = get_counter_from_timestamp(timestamp)
    valid_hotp(token, encoded_secret, counter)
  end

  defp get_encoded_secret(secret, opts) do
    case opts |> Keyword.get(:encoded_secret) do
      false ->
        Base.encode32(secret, padding: false)
      _ -> secret
    end
  end

  defp get_timestamp(opts) do
    if opts |> Keyword.get(:timestamp) do
      opts |> Keyword.get(:timestamp)
    else
      System.system_time(:seconds)
    end
  end

  defp get_counter_from_timestamp(timestamp) do
    trunc(timestamp / @default_timestep)
  end
end
