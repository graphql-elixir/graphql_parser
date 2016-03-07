defmodule GraphQL.Parser do

  def adapt_ast(map) when is_map(map) do
    map
    |> Enum.filter(fn {_,v} -> v != nil end)
    |> Enum.reduce(%{}, fn({k, v}, acc) ->
      if k in [:kind, :operation] do
        if v == "ArrayValue" do
          v = "ListValue"
        end
        Map.put(acc, k, String.to_atom(v))
      else
        Map.put(acc, k, adapt_ast(v))
      end
    end)
  end
  def adapt_ast(list) when is_list(list) do
    Enum.map(list, &adapt_ast/1)
  end
  def adapt_ast(x), do: x

  def parse(graphql) do
    result = GraphQL.Parser.Nif.parse(graphql)

    case result do
      {:ok, json} ->
        ast = Poison.Parser.parse!(json, keys: :atoms)
        {:ok, adapt_ast(ast)}
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
