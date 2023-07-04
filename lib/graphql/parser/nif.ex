defmodule GraphQL.Parser.Nif do
  @on_load {:init, 0}

  @moduledoc """
    NIF Module wrapping libgraphqlparser.

    Do not use this module directly. Use GraphQL.Parser module instead.
  """

  @doc false
  def init do
    path = :filename.join(priv_dir, 'graphql_parser')
    :ok = :erlang.load_nif(path, 1)
  end

  defp priv_dir do
    case :code.priv_dir(:graphql_parser) do
      {:error, _} ->
        :code.which(:graphql_parser)
        |> :filename.dirname
        |> :filename.dirname
        |> :filename.join('priv')

      path ->
        path
    end
  end

  def parse(_) do
    :erlang.nif_error(:nif_library_not_loaded)
  end
end
