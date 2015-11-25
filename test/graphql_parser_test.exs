defmodule GraphQL.ParserTest do
  use ExUnit.Case
  # doctest GraphQL.Parser

  import ExUnit.TestHelper

  test "simple query" do
    assert_parse_success "{ field }",
    %{definitions: [%{directives: nil, kind: "OperationDefinition",
      loc: %{end: 10, start: 1}, name: nil, operation: "query",
      selectionSet: %{kind: "SelectionSet", loc: %{end: 10, start: 1},
        selections: [%{alias: nil, arguments: nil, directives: nil,
           kind: "Field", loc: %{end: 8, start: 3},
           name: %{kind: "Name", loc: %{end: 8, start: 3}, value: "field"},
           selectionSet: nil}]}, variableDefinitions: nil}], kind: "Document",
    loc: %{end: 10, start: 1}}
  end

  test "complex query with variable inline values" do
    assert_parse_success "{ field(complex: { a: { b: [ $var ] } }) }",
    %{definitions: [%{directives: nil, kind: "OperationDefinition",
      loc: %{end: 43, start: 1}, name: nil, operation: "query",
      selectionSet: %{kind: "SelectionSet", loc: %{end: 43, start: 1},
        selections: [%{alias: nil,
           arguments: [%{kind: "Argument", loc: %{end: 40, start: 9},
              name: %{kind: "Name", loc: %{end: 16, start: 9},
                value: "complex"},
              value: %{fields: [%{kind: "ObjectField",
                   loc: %{end: 38, start: 20},
                   name: %{kind: "Name", loc: %{end: 21, start: 20},
                     value: "a"},
                   value: %{fields: [%{kind: "ObjectField",
                        loc: %{end: 36, start: 25},
                        name: %{kind: "Name", loc: %{end: 26, start: 25},
                          value: "b"},
                        value: %{kind: "ArrayValue", loc: %{end: 36, start: 28},
                          values: [%{kind: "Variable",
                             loc: %{end: 34, start: 30},
                             name: %{kind: "Name", loc: %{end: 34, start: 30},
                               value: "var"}}]}}], kind: "ObjectValue",
                     loc: %{end: 38, start: 23}}}], kind: "ObjectValue",
                loc: %{end: 40, start: 18}}}], directives: nil, kind: "Field",
           loc: %{end: 41, start: 3},
           name: %{kind: "Name", loc: %{end: 8, start: 3}, value: "field"},
           selectionSet: nil}]}, variableDefinitions: nil}], kind: "Document",
    loc: %{end: 43, start: 1}}
  end

  test "failure when fragments named on" do
    assert_parse_failure "fragment on on on { on }",
    "1.10-11: syntax error, unexpected on"
  end
end
