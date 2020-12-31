-module(mybank_atm).
-behaviour(gen_server).

-export([start_link/0, stop/0]).
-export([deposit/2, withdraw/2]).
-export([balance/1]).

%% gen server call backs
-export([init/1, terminate/2, code_change/3]).
-export([handle_call/3, handle_cast/2, handle_info/2]).

-record(state, {
  accounts
}).

%% ============ API

start_link() ->
  io:format("------> Opening bank.~n"),
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
  gen_server:stop(?MODULE).

deposit(AccountId, Amount) ->
  gen_server:call(?MODULE, {deposit, AccountId, Amount}).

withdraw(AccountId, Amount) ->
  gen_server:call(?MODULE, {withdraw, AccountId, Amount}).

balance(AccountId) ->
  gen_server:call(?MODULE, {balance, AccountId}).

%% =========== Internal

init([]) ->
  Accounts = dict:new(),
  State = #state{accounts = Accounts},
  {ok, State}.

handle_call({deposit, AccountId, Amount}, _From, #state{
  accounts = Accounts
} = State) ->
  io:format("------> ~p deposited ~p.~n", [AccountId, Amount]),
  CurrentBalance = get_current_balance(AccountId, Accounts),
  Accounts1 = dict:store(
    AccountId,
    CurrentBalance + Amount,
    Accounts
  ),
  {reply, ok, State#state{accounts = Accounts1}};

handle_call({balance, AccountId}, _From, #state{
  accounts = Accounts
} = State) ->
  CurrentBalance = get_current_balance(AccountId, Accounts),
  io:format("------> Balance of ~p is ~p. ~n", [AccountId, CurrentBalance]),
  {reply, CurrentBalance, State};

handle_call({withdraw, AccountId, Amount}, _From, #state{
  accounts = Accounts
} = State) ->
  CurrentBalance = get_current_balance(AccountId, Accounts),
  case CurrentBalance of
    Balance when (Balance - Amount) >= 0 ->
      Accounts2 = dict:store(AccountId, Balance - Amount, Accounts),
      {reply, ok, State#state{accounts = Accounts2}};

    _ ->
      {reply, {error, not_enough_money}, State}
  end;

handle_call(_Msg, _From, State) ->
  {reply, undefined, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("----------> Closing Bank.~n"),
  terminated.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

get_current_balance(AccountId, Accounts) ->
  case dict:find(AccountId, Accounts) of
    error -> 0;
    {ok, Amount0} -> Amount0
  end.
