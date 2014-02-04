-module(random_strings).

-export([solve/2]).

solve(Seq,Probs)->
  Probablys = lists:foldl( fun ( A , Acc ) ->
	{F,_} = string:to_float(A),
	Acc ++ [F] end,[],string:tokens(Probs," ")),

  V = prob_recurse(Seq,Probablys,[]),
  [ io:format("~w ",[T]) || T <- V ].

prob_recurse(_,[],Outs)-> Outs;
prob_recurse(Seq,Probs,Outs)->
  prob_recurse(Seq,tl(Probs),Outs ++ [ seq_recurse(Seq,hd(Probs),0) ]).

seq_recurse([],Prob,Out)->Out;
seq_recurse(Seq,Prob,Out)->
  InQ = hd(Seq),
  if
    ((InQ == 65) or
      (InQ == 84))-> 
      seq_recurse(tl(Seq),Prob,Out+ math:log10((1-Prob)/2));
    true -> 
      seq_recurse(tl(Seq),Prob,Out + math:log10(Prob/2))
  end.