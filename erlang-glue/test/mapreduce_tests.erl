-module(mapreduce_tests).
-include_lib("eunit/include/eunit.hrl").

%%% Testing of Map reduce using word count
map_reduce_test() ->
	M_func = fun(Line) ->
		lists:map(
			fun(Word) ->
				{Word, 1}
			end,
		Line)
	end,

	R_func = fun(V1, Acc) ->
		Acc + V1
	end,

	Result = mapreduce:map_reduce(3, 5, M_func, R_func, 0,
 		[[this, is, a, boy], [this, is, a, girl], [this, is, lovely, boy]]),
	?debugFmt("Result: ~p~n", [Result]).

