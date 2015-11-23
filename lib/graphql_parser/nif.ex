defmodule GraphqlParser.Nif do
  @on_load {:init, 0}
  @moduledoc """
    NIF Module wrapping the libgraphqlparser.

    Do not use this module directly. Use GraphqlParser module instead.
  """

  @doc false
  def init do
    path = Path.expand "graphqlparser" #TODO
    :ok = :erlang.load_nif(path, 1)
  end

  def parse(_) do
    exit(:nif_library_not_loaded)
  end
end
