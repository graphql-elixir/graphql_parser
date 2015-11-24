#include "c/GraphQLParser.h"
#include "c/GraphQLAstNode.h"
#include "c/GraphQLAstVisitor.h"
#include "c/GraphQLAst.h"
#include "c/GraphQLAstToJSON.h"

#include <string.h>
#include <stdio.h>

#include "erl_nif.h"


static ERL_NIF_TERM parse_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  ErlNifBinary graphql_binary;
  ErlNifBinary output_binary;

  struct GraphQLAstNode *ast;
  const char *error;
  size_t error_len;

  const char *json;
  size_t json_len;

  if (argc != 1) {
    return enif_make_badarg(env);
  }

  if(!enif_inspect_binary(env, argv[0], &graphql_binary)){
    return enif_make_badarg(env);
  }

  ast = graphql_parse_string((const char *)graphql_binary.data, &error);
  enif_release_binary(&graphql_binary);

  if (ast == NULL) {
    error_len = strlen(error);
    enif_alloc_binary(error_len, &output_binary);
    strncpy((char*)output_binary.data, error, error_len);
    return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_binary(env, &output_binary));
  }

  json = graphql_ast_to_json(ast);

  json_len = strlen(json);
  enif_alloc_binary(json_len, &output_binary);
  strncpy((char*)output_binary.data, json, json_len);
  return enif_make_tuple2(env, enif_make_atom(env, "ok"), enif_make_binary(env, &output_binary));
}

static ErlNifFunc nif_funcs[] =
{
  {"parse", 1, parse_nif}
};

ERL_NIF_INIT(Elixir.GraphQL.Parser.Nif, nif_funcs, NULL, NULL, NULL, NULL)
