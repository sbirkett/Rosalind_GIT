-module(ordered_permutations).

-import(kmers,[make_permutations/2,make_weighted_chars/1]).
-export([solve/2]).

solve(Chars,MaxSize)->
  compile:file("kmers.erl"),
  WeightedChars = kmers:make_weighted_chars(Chars),
  AllSets = make_all_sets(Chars,MaxSize,[]),
  OrderedSets = order_permutations(AllSets,WeightedChars),
  lists:map( fun ( A ) -> io:format("~s\n",[A]) end, OrderedSets).

order_permutations(Perms,Weights)->
    WeightDict = dict:from_list(Weights),

    Sorter = fun(X,Y) ->
      StrX = string:str(X,Y),
      StrY = string:str(Y,X),
      if
	( StrX == 1 ) and ( length(X) < length(Y) ) -> true;
	% need to find first non matching
	true ->
          XasInts = lists:foldl( fun( A, Acc) ->
            We = dict:fetch(A,WeightDict),
            Acc ++ [ dict:fetch(A,WeightDict) ] end,[], X),
          YasInts = lists:foldl( fun( A, Acc) ->
              Acc ++ [ dict:fetch(A,WeightDict) ] end, [], Y),
          {Xval,Xext} = string:to_integer(lists:flatten(XasInts)),
          {Yval,Yext} = string:to_integer(lists:flatten(YasInts)),
          Xval < Yval 
      end
  end,

    lists:sort(Sorter,Perms).

make_all_sets(_,0,Outs)->Outs;
make_all_sets(Chars,MaxSize,Outs)->
  make_all_sets(
    Chars,
    MaxSize-1,
    lists:merge(Outs,kmers:make_permutations(Chars,MaxSize))).
