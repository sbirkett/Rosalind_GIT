-module(independent_alleles).

-record(geno,{a,b,c,d}).
-record(genoNode,{parent,genotype,stat}).

-define(DefaultGeno,#geno{a=1,b=0,c=1,d=0}).

-export([solve/2,factorial/1]).

solve(K,N) ->
  LastGen = make_generations(K,[?DefaultGeno]),
  LikeGeno = length(like_defaultGeno(LastGen,[])),

  TotalOffspring = round(math:pow(2,K)),
  ProbForOne = (LikeGeno/length(LastGen)),

  % n = TotalOffspring
  % r = N
 
  % C(n,r)  = n!/(r!(n-r)!)

  % Answer = C(n,r) * p^r * (1-p)^(n-r)

  C = factorial(TotalOffspring) / ( factorial(N) * factorial(TotalOffspring-N)),

  C * math:pow(ProbForOne,N) * math:pow(1-ProbForOne,TotalOffspring-N).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).

make_generations(0,LastGen)-> LastGen;
make_generations(Count,LastGen)->
  NewGen =
    lists:foldl( fun(A,Acc) ->
	  lists:merge(Acc,breed(A,?DefaultGeno)) end,[],LastGen),
  make_generations(Count-1,NewGen).

breed(A,B)->
  Geno0 = #geno{a=A#geno.a,b=B#geno.a,c=A#geno.c,d=B#geno.c},
  Geno1 = #geno{a=A#geno.a,b=B#geno.a,c=A#geno.c,d=B#geno.d},
  Geno2 = #geno{a=A#geno.a,b=B#geno.a,c=A#geno.d,d=B#geno.d}, 
  Geno3 = #geno{a=A#geno.a,b=B#geno.b,c=A#geno.c,d=B#geno.c}, 
  Geno4 = #geno{a=A#geno.b,b=B#geno.b,c=A#geno.c,d=B#geno.c}, 
  Geno5 = #geno{a=A#geno.a,b=B#geno.b,c=A#geno.c,d=B#geno.d}, 
  Geno6 = #geno{a=A#geno.b,b=B#geno.b,c=A#geno.c,d=B#geno.d}, 
  Geno7 = #geno{a=A#geno.b,b=B#geno.b,c=A#geno.d,d=B#geno.d}, 
  [Geno0,Geno1,Geno2,Geno3,Geno4,Geno5,Geno6,Geno7].

like_defaultGeno([],Out)-> Out;
like_defaultGeno(Genos,Out)->
  Geno = hd(Genos),
  case compare_to_default(Geno) of
    true ->
      like_defaultGeno(tl(Genos),[Geno|Out]);
    false ->
      like_defaultGeno(tl(Genos),Out)
  end.

compare_to_default(A)->
  if
    A#geno.a == A#geno.b -> false;
    A#geno.c == A#geno.d -> false;
    true -> 
      true
  end.
