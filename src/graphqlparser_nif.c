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
  ErlNifBinary inp_bin;
  ErlNifBinary out_bin;
  const char *error;
  struct GraphQLAstNode *n;
  const char *json;
  int json_len;

  if(!enif_inspect_binary(env, argv[0], &inp_bin)){
    return enif_make_badarg(env);
  }

  n = graphql_parse_string((const char *)inp_bin.data, &error);
  json = graphql_ast_to_json(n);
  json_len = strlen(json);

  enif_release_binary(&inp_bin);

  enif_alloc_binary(json_len, &out_bin);
  strncpy((char*)out_bin.data, json, json_len);

  return enif_make_binary(env, &out_bin);
}

static ErlNifFunc nif_funcs[] =
{
  {"parse", 1, parse_nif}
};

ERL_NIF_INIT(Elixir.GraphQL.Parser.Nif, nif_funcs, NULL, NULL, NULL, NULL)
