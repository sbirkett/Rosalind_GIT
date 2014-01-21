-module(independent_alleles).

-record(geno,{a,b,c,d}).

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

  C * math:pow(ProbForOne,N). %* math:pow(1-ProbForOne,TotalOffspring-N).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).

make_generations(0,LastGen)-> LastGen;
make_generations(Count,LastGen)->
  NewGen =
    lists:foldl( fun(A,Acc) ->
	  lists:merge(Acc,breed(A,?DefaultGeno)) end,[],LastGen),
  make_generations(Count-1,NewGen).

breed(A,B)->

  % 0000
  Geno0 = #geno{ a=A#geno.a, b=B#geno.a, c=A#geno.c, d=B#geno.c },
  % 0001
  Geno1 = #geno{ a=A#geno.a, b=B#geno.a, c=A#geno.c, d=B#geno.d },
  % 0011
  Geno2 = #geno{ a=A#geno.a, b=B#geno.a, c=A#geno.d, d=B#geno.d }, 
  % 0100
  Geno3 = #geno{ a=A#geno.a, b=B#geno.b, c=A#geno.c, d=B#geno.c }, 
  % 1100
  Geno4 = #geno{ a=A#geno.b, b=B#geno.b, c=A#geno.c, d=B#geno.c }, 
  % 0101
  Geno5 = #geno{ a=A#geno.a, b=B#geno.b, c=A#geno.c, d=B#geno.d }, 
  % 1101
  Geno6 = #geno{ a=A#geno.b, b=B#geno.b, c=A#geno.c, d=B#geno.d }, 
  % 1111
  Geno7 = #geno{ a=A#geno.b, b=B#geno.b, c=A#geno.d, d=B#geno.d },
  % 1010
  Geno8 = #geno{ a=A#geno.b, b=B#geno.a, c=A#geno.d, d=B#geno.c },
  % 1011
  Geno9 = #geno{ a=A#geno.b, b=B#geno.a, c=A#geno.d, d=B#geno.d },
  % 1000
  Geno10= #geno{ a=A#geno.b, b=B#geno.a, c=A#geno.c, d=B#geno.c },
  % 0110
  Geno11= #geno{ a=A#geno.a, b=B#geno.b, c=A#geno.d, d=B#geno.c },
  % 0010
  Geno12= #geno{ a=A#geno.a, b=B#geno.a, c=A#geno.d, d=B#geno.c },
  % 0111
  Geno13= #geno{ a=A#geno.a, b=B#geno.b, c=A#geno.d, d=B#geno.d },
  % 1001
  Geno14= #geno{ a=A#geno.b, b=B#geno.a, c=A#geno.c, d=B#geno.d },
  % 1110
  Geno15= #geno{ a=A#geno.b, b=B#geno.b, c=A#geno.d, d=B#geno.c },
  [Geno0,Geno1,Geno2,Geno3,Geno4,Geno5,Geno6,Geno7,Geno8,Geno9,Geno10,Geno11,Geno12,Geno13,Geno14,Geno15].

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
