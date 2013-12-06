-module(list_permutations).

-export([start/1]).

start(N)->
  W = perms(make_int_list(list_to_integer(N),[])),
  io:format("~w\n",[length(W)]),
  lists:foldl( fun(I,Acc) ->
	
	lists:foldl( fun ( Q,Acc2) ->

	      io:format("~w ",[Q])
	      
	  end,[],I),
	
	io:format("\n")
    end, [],W).


make_int_list(N,X)->
  if
    N == 0 -> X;
    true -> make_int_list(N-1,[N|X])
  end.

perms([]) -> 
  [[]];

perms(L)  -> 
  [[H|T] || H <- L, T <- perms(L--[H])].
