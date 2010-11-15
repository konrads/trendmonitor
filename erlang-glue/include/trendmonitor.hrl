%% Trend notifier definitions

-type(message()                 :: string() | undefined).
-type(rating()                  :: bull | bear | neutral).

% UTC date time representation (as returned by erlang:universaltime/0).
-type(utc()                     :: {{integer(), integer(), integer()}, {integer(), integer(), integer()}}).

-type(price()                   :: float()).

-type(volume()                  :: integer()).

-define(POSTER, "Tweeter notifier").

-record(swing, {
    code                        :: message(),
    rating                      :: rating(),
    percentage                  :: float()
}).


-record(trade, {
    code                        :: string(),
    price                       :: float(),
    volume                      :: integer()
}).

-record(avg_trades, {
    code                        :: string(),
    avg                         :: float(),
    trades                      :: [{price(), volume()}]
}).
