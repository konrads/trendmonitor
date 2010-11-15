-module(multinode_mapreduce).
-export([pmap/2]).

pmap(MapF, L) ->
    Nodes = [node()|nodes()],
    SpawnerP = self(),
    MapFOnDiffN = fun(I, [HeadN|TailNs]) ->
                      CallerF = fun() ->
                                    SpawnerP ! {self(), MapF(I)}
                                end,
                      MapPid = spawn(HeadN, CallerF),
                      RoundRobinedNs = [TailNs ++ HeadN],
                      {MapPid, RoundRobinedNs}
                  end,
    {Pids, _} = lists:mapfoldl(MapFOnDiffN, Nodes, L),
    % collect results
    [receive {P, Result} -> Result end || P <- Pids].
