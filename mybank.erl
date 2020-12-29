%%%-------------------------------------------------------------------
%%% @author ivanermolaev
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Dec 2020 10:07
%%%-------------------------------------------------------------------
-module(mybank).
-author("ivanermolaev").

%% API
-export([start/0, stop/0, deposit/2, withdraw/2, balance/1]).

start() ->
  mybank_sup:start().

stop() ->
  mybank_sup:stop().

deposit(Name, Balance) ->
  mybank_atm:deposit(Name, Balance).

withdraw(Name, Balance) ->
  mybank_atm:withdraw(Name, Balance).

balance(Name) ->
  mybank_atm:balance(Name).
