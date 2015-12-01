defmodule GraphQL.Parser do
  def parse(graphql) do
    result = GraphQL.Parser.Nif.parse(graphql)

    case result do
      {:ok, json} ->
        {:ok, Poison.Parser.parse!(json, keys: :atoms)}
      {:error, message} ->
        {:error, message}
    end
  end

  def parse!(graphql) do
    result = GraphQL.Parser.Nif.parse graphql

    case result do
      {:ok, json} ->
        Poison.Parser.parse!(json, keys: :atoms)
      {:error, message} ->
        raise GraphQL.Parser.SyntaxError, message: message
    end
  end
end
