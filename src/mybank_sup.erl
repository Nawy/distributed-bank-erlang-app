%%%-------------------------------------------------------------------
%%% @author ivanermolaev
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Dec 2020 10:28
%%%-------------------------------------------------------------------
-module(mybank_sup).
-behavior(supervisor).
-author("ivanermolaev").

%% API
-export([start_link/0, stop/0]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop() ->
  ?MODULE ! terminate.

init([]) ->
  Children = [
    {
      %% id
      mybank_atm,
      %% {module, start link, args}
      {mybank_atm, start_link, []},
      %% restart type
      permanent,
      %% shutdown
      10000,
      %% type
      worker,
      %% modules
      [mybank_atm]
    }
  ],
  %% Intensity (10) maximum number of restarts into the give period of time (10 seconds)
  {ok, {{one_for_one, 10, 10}, Children}}.

