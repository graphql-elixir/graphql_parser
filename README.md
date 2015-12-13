# GraphQL.Parser

An Elixir binding for [libgraphqlparser](https://github.com/graphql/libgraphqlparser)
for parsing [GraphQL](http://graphql.org).

## Installation

Add GraphQL.Parser to your deps in `mix.exs`:

```elixir
defp deps do
  [{:graphql_parser, github: "aarvay/graphql_parser"}]
end
```

Then, update your deps:

```sh
$ mix deps.get
```

## Usage

```elixir
iex> GraphQL.Parser.parse "{ hello }"
{:ok,
 %{definitions: [%{directives: nil, kind: "OperationDefinition",
      loc: %{end: 10, start: 1}, name: nil, operation: "query",
      selectionSet: %{kind: "SelectionSet", loc: %{end: 10, start: 1},
        selections: [%{alias: nil, arguments: nil, directives: nil,
           kind: "Field", loc: %{end: 8, start: 3},
           name: %{kind: "Name", loc: %{end: 8, start: 3}, value: "hello"},
           selectionSet: nil}]}, variableDefinitions: nil}], kind: "Document",
   loc: %{end: 10, start: 1}}}

iex> GraphQL.Parser.parse! "{ hello }"
%{definitions: [%{directives: nil, kind: "OperationDefinition",
     loc: %{end: 10, start: 1}, name: nil, operation: "query",
     selectionSet: %{kind: "SelectionSet", loc: %{end: 10, start: 1},
       selections: [%{alias: nil, arguments: nil, directives: nil,
          kind: "Field", loc: %{end: 8, start: 3},
          name: %{kind: "Name", loc: %{end: 8, start: 3}, value: "hello"},
          selectionSet: nil}]}, variableDefinitions: nil}], kind: "Document",
  loc: %{end: 10, start: 1}}

iex> GraphQL.Parser.parse! " hello }"
** (GraphQL.Parser.SyntaxError) 1.2-6: syntax error, unexpected IDENTIFIER, expecting fragment or mutation or query or { on line
    lib/graphql/parser.ex:20: GraphQL.Parser.parse!/1
```

## ToDo

- [x] PoC
- [x] Bring all build processes under Mix
- [ ] Bind the entire AST
- [x] Add tests

## License

Copyright (c) 2015 Vignesh Rajagopalan

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
