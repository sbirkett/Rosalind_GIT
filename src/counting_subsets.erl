-module(counting_subsets).

-export([solve/1,binom/2]).

solve(N)->
  do_recurse(N,N,0).

do_recurse(_,0,Out)->Out+1;
do_recurse(K,N,Out)->
  do_recurse(K,N-1,Out+binom(K,N)).

binom(K,N)->
  factorial(K) / ( factorial(N) * factorial(K-N)).
  
factorial(0)->1;
factorial(N)->N * factorial(N-1).
