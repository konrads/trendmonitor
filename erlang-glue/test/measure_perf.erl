-module(measure_perf).
-export([measure_perf/2, run_times/2]).
-include_lib("eunit/include/eunit.hrl").

-define(MAX_OVERLOADS, 100).
-define(MAX_CALLS, 100).

run_times(0, _F) ->
	ok;
run_times(N, F) ->
	F(),
	run_times(N-1, F).

create_pattern(0, F, Acc) ->
	Acc2 = Acc ++ F(0) ++ ".\n",
	Acc2;
create_pattern(N, F, Acc) ->
	Acc2 = Acc ++ F(N) ++ ";\n",
	create_pattern(N-1, F, Acc2).

measure_perf(N, F) ->
	StartTotal = {StartMegaS, StartS, StartMicroS} = now(),
	StartInMicro = StartMegaS * 1000000 + StartS * 1000 + StartMicroS,
	run_times(N, F),
	EndTotal = {EndMegaS, EndS, EndMicroS} = now(),
	EndInMicro = EndMegaS * 1000000 + EndS * 1000 + EndMicroS,
	?debugFmt("Start: ~p  End: ~p~n", [StartTotal, EndTotal]),
	?debugFmt("Average call time: ~p~n", [(EndInMicro-StartInMicro)/N]).

pattern_match_perf_test() ->
	ModCode = "-module(pattern_match_perf_test).\n"
               ++ "-export([pattern_match/1]).\n"
	       ++ create_pattern(?MAX_OVERLOADS,
                                 fun(N) -> 
                                      NAsStr = integer_to_list(N),
                                      "pattern_match(" ++ NAsStr ++ ") -> " ++ NAsStr
                                  end,
                                  []),
	% ?debugFmt("Code: ~n~s~n", [ModCode]),
	dynamic_compile:load_from_string(ModCode),
	measure_perf:measure_perf(?MAX_CALLS, fun() -> pattern_match_perf_test:pattern_match(?MAX_OVERLOADS div 2) end).

guard_match_perf_test() ->
	ModCode = "-module(guard_match_perf_test).\n"
               ++ "-export([guard_match/1]).\n"
	       ++ create_pattern(?MAX_OVERLOADS,
                                 fun(N) -> 
                                      NAsStr = integer_to_list(N),
                                      "guard_match(N) when N =:= " ++ NAsStr ++ " -> " ++ NAsStr
                                 end,
                                 []),
	% ?debugFmt("Code: ~n~s~n", [ModCode]),
	dynamic_compile:load_from_string(ModCode),
	measure_perf:measure_perf(?MAX_CALLS, fun() -> guard_match_perf_test:guard_match(?MAX_OVERLOADS div 2) end).
