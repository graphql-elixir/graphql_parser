defmodule GraphQL.Parser.Mixfile do
  use Mix.Project

  def project do
    [app: :graphql_parser,
     version: "0.0.1",
     elixir: "~> 1.1",
     compilers: [:libgraphqlparser, :graphqlparsernif, :elixir, :app],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:poison, "~> 1.5"}]
  end
end

defmodule GraphQL.Parser.MixHelper do
  def check_exit_status({res, exit_status_code}) do
    if exit_status_code != 0 do
      raise Mix.Error, message: """
        Build command exited with status code: #{exit_status_code}.
        Make sure you're running `mix compile` from project's root.
      """
    end

    IO.binwrite res # verbose
  end
end

defmodule Mix.Tasks.Compile.Libgraphqlparser do
  use Mix.Task
  import GraphQL.Parser.MixHelper

  @shortdoc "Compiles libgraphqlparser"

  def run(_) do

    try do
      System.cmd("cmake", ["."], cd: "libgraphqlparser", stderr_to_stdout: true)
        |> check_exit_status

      System.cmd("make", [], cd: "libgraphqlparser", stderr_to_stdout: true)
        |> check_exit_status

      System.cmd("make", ["install"], cd: "libgraphqlparser", stderr_to_stdout: true)
        |> check_exit_status

    rescue
      e in Mix.Error ->
        raise e
      e in ErlangError ->
        case e.original do
          :enoent ->
            raise Mix.Error, message: """
              Please check if `cmake` and `make` are installed
            """
        end
    end
  end
end

defmodule Mix.Tasks.Compile.Graphqlparsernif do
  use Mix.Task
  import GraphQL.Parser.MixHelper

  @shortdoc "Compiles the GraphQL.Parser NIF library"

  def run(_) do

    compiler_inputs = [
      "-undefined", "dynamic_lookup", "-dynamiclib",
      "-I", "/usr/local/include/graphqlparser",
      "-I", "#{:code.root_dir ++ '/erts-' ++ :erlang.system_info(:version) ++ '/include' |> to_string}",
      "-L", "/usr/local/lib",
      "-l", "graphqlparser",
      "src/graphqlparser_nif.c",
      "-o", "graphqlparser.so"
    ]

    try do
      System.cmd("gcc", compiler_inputs, stderr_to_stdout: true)
        |> check_exit_status

    rescue
      e in Mix.Error ->
        raise e
      e in ErlangError ->
        case e.original do
          :enoent ->
            raise Mix.Error, message: """
              Please check if `cmake` and `make` are installed
            """
        end
    end
  end
end
