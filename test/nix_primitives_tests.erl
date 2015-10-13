%%%'   HEADER
%% @author    Susan Potter <me@susanpotter.net>
%% @copyright 2015 Susan Potter
%% @doc       EUnit test suite module to check parsing Nix primitives.
%% @end

-module(nix_primitives_tests).
-author('Susan Potter <me@susanpotter.net>').

-define(NOTEST, true).
-define(NOASSERT, true).
-define(XRLFILE, "nixerl_scan.xrl").
-define(YRLFILE, "nixerl_parse.yrl").
-define(SCANMOD, nixerl_scan).
-define(PARSEMOD, nixerl_parse).
-include_lib("eunit/include/eunit.hrl").

%%%.
%%%' TEST GENERATOR
generator_test_() ->
  {setup, fun setup/0, fun cleanup/1,
    {inparallel,
      [
        ?_assertMatch({ok, [null], 1}, nixerl_scan:string("null")),
        ?_assertMatch({ok, [{'let', 1}], 1}, nixerl_scan:string("let")),
        ?_assertMatch({ok, [{'in', 1}], 1}, nixerl_scan:string("in")),
        ?_assertMatch({ok, [{integer, 1234, 1}], 1}, nixerl_scan:string("1234")),
        ?_assertMatch({ok, [{boolean, true, 1}], 1}, nixerl_scan:string("true")),
        ?_assertMatch({ok, [{boolean, false, 1}], 1}, nixerl_scan:string("false")),
        ?_assertMatch({ok, [{string, "bla", 1}], 1}, nixerl_scan:string("\"bla\"")),
        ?_assertMatch({ok, [{string, "bla", 1}], 1}, nixerl_scan:string("''bla''")),
        ?_assertMatch({ok, [{path, "./input.txt", 1}], 1}, nixerl_scan:string("./input.txt")),
        ?_assertMatch({ok, [{path, "/etc", 1}], 1}, nixerl_scan:string("/etc")),
        ?_assertMatch({ok, [{path, "../bla.png", 1}], 1}, nixerl_scan:string("../bla.png"))
      ]
    }
  }.
%%%.
%%%' HELPER FUNCTIONS
setup() ->
  {ok, XerlFile} = leex:file(?XRLFILE),
  {ok, ?SCANMOD} = compile:file(XerlFile),
  {ok, YerlFile} = yecc:file(?YRLFILE),
  {ok, ?PARSEMOD} = compile:file(YerlFile),
  [XerlFile, YerlFile].

cleanup([XerlFile, YerlFile]) ->
  ok = file:delete(XerlFile),
  ok = file:delete(YerlFile),
  ok.
%%%.
%%% vim: set filetype=erlang tabstop=2 foldmarker=%%%',%%%. foldmethod=marker:

