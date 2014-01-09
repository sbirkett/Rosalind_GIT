-module(expected_offspring).

-export([start/1]).

start(N)->
  Vals = lists:foldl( fun( A, Acc) ->
	{T,X} = string:to_integer(A),
	Acc ++ [T] end,[],string:tokens(N," ")),
  Modifiers = [ 1, 1, 1, 0.75, 0.50, 0 ],
  solve(Vals,Modifiers,0).
  
solve([],[],Tot) ->
  Tot;
solve(Vals,Mods,Tot)->
  solve(tl(Vals),tl(Mods),Tot + ( (hd(Vals) * 2) * hd(Mods))).
