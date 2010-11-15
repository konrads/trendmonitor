%% @doc Callbacks for the Trendmonitor application.

-module(trendmonitor_app).
-author('KS').

-behaviour(application).
-include("trendmonitor.hrl").
-export([start/2, stop/1]).  %% application callbacks

-export([start/0, stop/0, prep_mnesia/0]).  %% external app controls

start() ->
    application:start(trendmonitor).

stop() ->
    application:stop(trendmonitor).

-spec(start(term(), term()) -> 'ignore' | {'error',_} | {'ok',pid()}).
start(Type, StartArgs) ->
	error_logger:info_msg("Type: ~p~nStartArgs: ~p~n", [Type, StartArgs]),
	mnesia:start(),
	mnesia:set_debug_level(debug),
	trendmonitor_sup:start_link(StartArgs).

-spec(stop(term()) -> ok).
stop(State) ->
	error_logger:info_msg("State: ~p~n", [State]),
	ok.

prep_mnesia() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:set_debug_level(debug),
	mnesia:create_table(avg_trades, [{attributes, record_info(fields, avg_trades)}, {disc_copies, [node()]}]).
