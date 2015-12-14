defmodule GraphQL.Parser.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :graphql_parser,
     name: "GraphQL.Parser",
     version: @version,
     elixir: "~> 1.1",
     compilers: [:libgraphqlparser, :nif] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     docs: docs,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:poison, "~> 1.5"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp description do
    """
    An elixir interface for libgraphqlparser implemented as a NIF for parsing
    GraphQL.
    """
  end

  defp package do
    [maintainers: ["Vignesh Rajagopalan"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/aarvay/graphql_parser"},
     files: ["lib", "src", "Makefile", "mix.exs", "README.md",
             "libgraphqlparser/ast/ast.ast", "libgraphqlparser/ast/*.py",
             "libgraphqlparser/c/*.cpp", "libgraphqlparser/c/*.h",
             "libgraphqlparser/*.h", "libgraphqlparser/*.cpp",
             "libgraphqlparser/*.lpp", "libgraphqlparser/*.hh",
             "libgraphqlparser/*.hpp", "libgraphqlparser/*.ypp",
             "libgraphqlparser/CMakeLists.txt", "libgraphqlparser/LICENSE",
             "libgraphqlparser/PATENTS", "libgraphqlparser/README.md"]]
  end

  defp docs do
    [source_ref: "v#{@version}",
     extras: ["README.md"],
     main: "README"]
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
      File.mkdir_p!("libgraphqlparser/python")
      File.touch!("libgraphqlparser/python/CMakeLists.txt")

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

defmodule Mix.Tasks.Compile.Nif do
  use Mix.Task
  import GraphQL.Parser.MixHelper

  @shortdoc "Compiles the NIF library"

  def run(_) do
    try do
      File.mkdir_p!("priv")
      System.cmd("make", [], stderr_to_stdout: true) |> check_exit_status
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
