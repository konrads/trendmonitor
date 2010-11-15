{application, trendmonitor,  [
	{description, "Pricing trends monitor"},
	{vsn, "0.1"}, 
	{modules, [broadcast_server,
		computation_server,
		notification_server,
		trendmonitor_app,
		trendmonitor_sup,
		mapreduce,
		multinode_mapreduce]},
	{registered, []},
	{applications, [kernel, stdlib]},
	{env, [{ejabberd_credentials, {"trendmonitor", "password"}}]}
]}.

