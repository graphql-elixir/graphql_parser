defmodule GraphQL.Parser do
  def parse(string) do
    GraphQL.Parser.Nif.parse string
  end
end
