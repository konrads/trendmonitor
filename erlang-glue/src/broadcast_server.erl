-module(broadcast_server).
-behaviour(gen_server).
-include("trendmonitor.hrl").
-export([broadcast/1, start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

broadcast(Swing=#swing{}) ->
	gen_server:call(?MODULE, {broadcast, Swing}).

init([]) ->
	%% Note we must set trap_exit = true if we
	%% want terminate/2 to be called when the application
	%% is stopped
	process_flag(trap_exit, true),
	io:format("Starting ~p...~n" ,[?MODULE]),
	{ok, 0}.

handle_call({broadcast, Swing}, _From, State) -> {reply, broadcast_internal(Swing), State}.

handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) ->
	io:format("Stopping ~p...~n" ,[?MODULE]),
	ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

broadcast_internal(Swing) ->
	io:format("Broadcasting swing ~p~n" ,[Swing]).
