%% @author birketsc
%% @doc @todo Add description to baby_bathwater.

-module(baby_bathwater).

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/2,binom/3,pascal/1]).

solve(N,M)->
  PascalsTriangle = pascal(N+1),
  round(
    lists:foldl( 
      fun(A,Acc) ->
        Acc + binom(N+1,A+1,PascalsTriangle) 
        end,0,lists:seq(M,N))) rem 1000000.

%% ====================================================================
%% Internal functions
%% ====================================================================

binom(N,K,Triangle)->
  lists:nth(K,lists:nth(N,lists:reverse(Triangle))).

pascal(1)-> [[1]];
pascal(N) ->
    L = pascal(N-1),
    [H|_] = L,
    [lists:zipwith(fun(X,Y)->X+Y end,[0]++H,H++[0])|L].