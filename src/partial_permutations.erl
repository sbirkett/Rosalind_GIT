-module(partial_permutations).

-export([calculate/2]).

calculate(N,K) ->
  calc_rec(N-1,N-K,N) rem 1000000.

calc_rec(N,K,Out)->
  case N == K of 
      true -> Out;
      false -> calc_rec(N-1,K,Out * N)
    end.
