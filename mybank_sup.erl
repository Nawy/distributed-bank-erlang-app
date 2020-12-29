%%%-------------------------------------------------------------------
%%% @author ivanermolaev
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Dec 2020 10:28
%%%-------------------------------------------------------------------
-module(mybank_sup).
-author("ivanermolaev").

%% API
-export([start/0, stop/0, init/0]).

start() ->
  Pid = spawn(?MODULE, init, []),
  register(?MODULE, Pid).

stop() ->
  ?MODULE ! terminate.

init() ->
  process_flag(trap_exit, true),
  {ok, SupervisedPid} = mybank_atm:start_link(),
  main_loop(SupervisedPid).

main_loop(SupervisedPid) ->
  receive
    {'EXIT', SupervisedPid, _} ->
      error_logger:error_msg("mybank process died, respawning"),
      {ok, SupervisedPid} = mybank_atm:start_link(),
      main_loop(SupervisedPid);
    terminate ->
      mybank_atm:stop()
  end.
