
-module(osmos_merge_vals).
-author('Bob Dionne').
%%
%%
-export([run/0, merge_vals/3]).
%%
-include("../src/osmos.hrl").
%%
run() ->
    ok = osmos:start(),
    %%Fmt = osmos_table_format:new (binary, term_replace, 1024),
    Dir = "tmp." ++ os:getpid (),
    F = #osmos_table_format {
      block_size = 1024,
      key_format = osmos_format:binary(),
      key_less = fun osmos_table_format:erlang_less/2,
      value_format = osmos_format:term(),
      merge = fun ?MODULE:merge_vals/3,
      short_circuit = fun osmos_table_format:always/2,
      delete = fun osmos_table_format:never/2},
    { ok, table } = osmos:open(table, [{directory, Dir}, {format, F}]),
    ok = osmos:write(table, <<"foo">>, [1]),
    ok = osmos:write(table, <<"foo">>, [2]),

    {ok, Foo} = osmos:read(table, <<"foo">>),
    io:format("We read ~w ~n", [Foo]),
    ok = osmos:close (table),
    ok = osmos:stop ().
%%
merge_vals(_Key, OldVal, NewVal) ->
    lists:append(OldVal, NewVal).

    



