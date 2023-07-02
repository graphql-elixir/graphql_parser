# GraphQL.Parser

An Elixir binding for [libgraphqlparser](https://github.com/graphql/libgraphqlparser)
implemented as a NIF for parsing [GraphQL](http://graphql.org).

## Introduction

GraphQL is a query language designed to build client applications by providing
an intuitive and flexible syntax and system for describing their data requirements
and interactions.

This library is an Elixir interface for the query language parser and not a full
implementation of GraphQL. It takes a query string as input and outputs the AST
in a format suitable for performing pattern matching. Use this library directly
only if you want to write your own implementation of GraphQL or you want to work
with AST for something else. For the full Elixir implementation, checkout
[graphql-elixir](https://github.com/joshprice/graphql-elixir). Head
[here](https://facebook.github.io/graphql) if you are looking out for the full
GraphQL specification.

## Requirements

A C++ compiler that supports C++11, cmake, and make, for building and installing
libgraphqlparser. It also requires Mac OS X or Linux.

## Installation

To get started quickly, add GraphQL.Parser to your deps in `mix.exs`:

```elixir
defp deps do
  [{:graphql_parser, "~> 0.0.4"}]
end
```

then, update your deps:

```sh
$ mix deps.get
```

### Installing libgraphqlparser
You need to install libgraphqlparser before attemting to compile & run this
library. If you're on a mac, you could do `brew install libgraphqlparser`.

But I'd recommend building and installing from source, because the library is
constantly updated with critical bug fixes. It's in pretty early stages, so
this is the most recommended approach. To install from source :

```sh
$ cd libgraphqlparser/
$ cmake .
$ make
$ make install
```

Once libgraphqlparser is successfully installed, do a `mix compile` to compile the NIF and you're good to go!

## Examples

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
