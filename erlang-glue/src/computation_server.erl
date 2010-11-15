-module(computation_server).
-behaviour(gen_server).
-include("trendmonitor.hrl").
-export([compute/1, start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(MAX_RECORDS, 10).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

-spec(compute(#trade{}) -> atom()).
compute(Trade=#trade{}) ->
	gen_server:call(?MODULE, {compute, Trade}).

init([]) ->
	%% Note we must set trap_exit = true if we
	%% want terminate/2 to be called when the application
	%% is stopped
	process_flag(trap_exit, true),
	io:format("Starting ~p...~n" ,[?MODULE]),
	{ok, 0}.

handle_call({compute, Trade}, _From, State) -> {reply, compute_internal(Trade), State}.

handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) ->
	io:format("Stopping ~p...~n" ,[?MODULE]),
	ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

-spec(compute_internal(#trade{}) -> ok).
compute_internal(Trade) ->
	io:format("Computing trade ~p~n" ,[Trade]),
	F = fun() ->
			% first read the previous trade list, if empty, create one
			% calculate average
			% persist new states
            AvgTrades = case mnesia:read(avg_trades, Trade#trade.code) of
		        [] ->
                    #avg_trades{code = Trade#trade.code,
                                avg = Trade#trade.price * Trade#trade.volume,
                                trades = [{Trade#trade.price, Trade#trade.volume}]};
		        [CurrAvgTrades = #avg_trades{trades = Trades}] ->
		            %io:format("old trades: ~p~n" ,[Trades]),
				    Trades2 = case length(Trades) of 
					    ?MAX_RECORDS -> tl(Trades) ++ [{Trade#trade.price, Trade#trade.volume}];
						_            -> Trades ++ [{Trade#trade.price, Trade#trade.volume}]
					end,
                    {Sum, Volume} = lists:foldr(fun({P, V}, {Sum, Volume}) -> {(P*V) + Sum, V+Volume} end, {0, 0}, Trades2),
                    CurrAvgTrades#avg_trades{avg = Sum/Volume, trades = Trades2}
            end,
            io:format("Building up item set ~p~n" ,[AvgTrades]),

        mnesia:write(AvgTrades)
	end,
	mnesia:transaction(F),

	broadcast_server:broadcast(#swing{rating=bull, percentage=Trade#trade.volume * Trade#trade.price, code=Trade#trade.code}).
