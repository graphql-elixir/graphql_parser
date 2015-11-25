defmodule ExUnit.TestHelper do
  import ExUnit.Assertions

  def assert_parse_success(input, output) do
    assert {:ok, output} == GraphQL.Parser.parse(input)
  end

  def assert_parse_failure(input, output) do
    assert {:error, output} == GraphQL.Parser.parse(input)
  end
end

ExUnit.start()
