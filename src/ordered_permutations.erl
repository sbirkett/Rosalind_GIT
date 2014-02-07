-module(ordered_permutations).

-import(kmers,[make_permutations/2,make_weighted_chars/1]).
-export([solve/2]).

solve(Chars,MaxSize)->

  % Helper file that alread makes permutations of a set size
  compile:file("kmers.erl"),

  % Make char/weight combinations
  WeightedChars = make_weighted_chars(Chars,[],0),
  io:format("~w\n",[WeightedChars]),
  % Make a permutations for all sizes
  AllSets = make_all_sets(Chars,MaxSize,[]),

  % Order and print out
  OrderedSets = order_permutations(AllSets,WeightedChars),

  file:delete("Output.txt"),
  {ok,OutFile} = file:open("Output.txt", [read, write]),
  lists:map( fun ( A ) -> 
	file:write(OutFile,A),
	file:write(OutFile,"\n") end, OrderedSets).

make_weighted_chars([],Outs,_) -> Outs;
make_weighted_chars(Chars,Outs,Index)->
  make_weighted_chars(tl(Chars),[{hd(Chars),Index}|Outs],Index+1).

order_permutations(Perms,Weights)->
    WeightDict = dict:from_list(Weights),

    % Sorting function
    Sorter = fun(X,Y) ->
      StrX = string:str(X,Y),
      StrY = string:str(Y,X),
      if
	( StrX == 1 )  -> false;
	( StrY == 1 )  -> true;
	% need to find first non matching
	true ->
	  {CharX,CharY} = get_first_non_matching(X,Y),
          dict:fetch(CharX,WeightDict) < dict:fetch(CharY,WeightDict)
      end
  end,
    lists:sort(Sorter,Perms).

get_first_non_matching(A,B)->
  case ( hd(A) == hd(B) ) of 
    false -> {hd(A),hd(B)};
    true -> get_first_non_matching(tl(A),tl(B))
  end.

make_all_sets(_,0,Outs)->Outs;
make_all_sets(Chars,MaxSize,Outs)->
  make_all_sets(
    Chars,
    MaxSize-1,
    lists:merge(Outs,kmers:make_permutations(Chars,MaxSize))).
