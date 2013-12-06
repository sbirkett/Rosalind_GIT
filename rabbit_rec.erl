-module(rabbit_rec).
-export([start/1]).

-include_lib("rosalind_records.hrl").

start(X) -> 
  Vals = string:tokens(X," "),
  K = list_to_integer(lists:last(Vals)),
  N = list_to_integer(hd(Vals)),
  hd(lists:last(breed_start(N,K,[[0,1]]))).

breed_start(N,K,List)->
  if
    N == 0 -> List;
    true ->
      LastPair = lists:last(List),
      LastAdults = hd(LastPair),
      LastKids = lists:last(LastPair),
      NewNode = [LastAdults+LastKids,LastAdults*K],
      breed_start(N-1,K,List ++ [NewNode])
  end.
