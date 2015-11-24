defmodule GraphQL.Parser.SyntaxError do
  defexception line: nil, message: "syntax error"

  def message(exception) do
    "#{exception.message} on line #{exception.line}"
  end
end
