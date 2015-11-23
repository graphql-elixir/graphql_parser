defmodule GraphqlParser do

  def parse(string) do
    GraphqlParser.Nif.parse string
  end
end
