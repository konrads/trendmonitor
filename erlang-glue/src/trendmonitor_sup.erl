-module(trendmonitor_sup).
-export([start_link/1, init/1]).
-behaviour(supervisor).

start_link(Args) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
	{ok, {{one_for_one, 3, 10},
                  [
		   {computation_server_tag,
			{computation_server, start_link, []},
			permanent,
			10000,
			worker,
			[computation_server]},
		   {broadcast_server_tag,
			{broadcast_server, start_link, []},
			permanent,
			10000,
			worker,
			[broadcast_server]},
		   {notification_server_tag,
			{notification_server, start_link, []},
			permanent,
			10000,
			worker,
			[notification_server]}
		  ]}}.
