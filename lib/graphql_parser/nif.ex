defmodule GraphqlParser.Nif do
  @on_load {:init, 0}
  @moduledoc """
    NIF Module wrapping the libgraphqlparser.

    Do not use this module directly. Use GraphqlParser module instead.
  """

  @doc false
  def init do
    path = "path to dynamically compiled module" #TODO
    :ok = :erlang.load_nif(path, 1)
  end
end
