-module(independent_alleles).

-export([solve/2,factorial/1]).

solve(K,N) ->

  TotalProgeny = round(math:pow(2,K)),
  binomial_rec(TotalProgeny,N,1/4,0).

binomial_rec(K,N,P,Out)->
  Val = do_binomial(K,N,P),
  case K == N of
    true ->
      Out + Val;
    false ->
      binomial_rec(K,N+1,P,Out+Val)
  end.

do_binomial(K,N,P)->

  ( factorial ( K ) / ( factorial(N) * factorial(K-N) ) ) *
  math:pow( P, N) * math:pow(1-P,K-N).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).