#include "c/GraphQLParser.h"
#include "c/GraphQLAstNode.h"
#include "c/GraphQLAstVisitor.h"
#include "c/GraphQLAst.h"
#include "c/GraphQLAstToJSON.h"

#include <string.h>
#include <stdio.h>

#include "erl_nif.h"

// Ensure c strings are always null terminated
char * alloc_and_copy_to_cstring(ErlNifBinary *);

static ERL_NIF_TERM parse_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  ErlNifBinary graphql_binary;
  const char *input;
  struct GraphQLAstNode *ast;

  const char *json;
  size_t json_len;
  ErlNifBinary output_binary;

  const char *error;
  size_t error_len;

  if (argc != 1 || !enif_inspect_binary(env, argv[0], &graphql_binary)) {
    return enif_make_badarg(env);
  }

  input = alloc_and_copy_to_cstring(&graphql_binary);
  enif_release_binary(&graphql_binary);

  ast = graphql_parse_string(input, &error);
  enif_free((void *)input);

  if (ast == NULL) {
    error_len = strlen(error);
    enif_alloc_binary(error_len, &output_binary);
    strncpy((char *)output_binary.data, error, error_len);

    return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_binary(env, &output_binary));
  }

  json = graphql_ast_to_json(ast);
  json_len = strlen(json);
  enif_alloc_binary(json_len, &output_binary);
  strncpy((char*)output_binary.data, json, json_len);

  return enif_make_tuple2(env, enif_make_atom(env, "ok"), enif_make_binary(env, &output_binary));
}

char * alloc_and_copy_to_cstring(ErlNifBinary *string)
{
  char *str = (char *) enif_alloc(string->size + 1);
  strncpy(str, (char *)string->data, string->size);
  str[string->size] = 0;
  return str;
}

static ErlNifFunc nif_funcs[] =
{
  {"parse", 1, parse_nif}
};

ERL_NIF_INIT(Elixir.GraphQL.Parser.Nif, nif_funcs, NULL, NULL, NULL, NULL)
