-module(kmers).

-export([start/1]).

-include_lib("nodes.hrl").

-import(node_stuff,[regular_node/2]).
-import(node_stuff,[regular_node_head/1]).
-import(node_stuff,[read_until_head/1]).

start(N)->
  {ok, Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  CharsAndLen = string:tokens(D,"\n"),
  Chars = string:tokens(hd(CharsAndLen)," "),
  {Len,Ext} = string:to_integer(hd(tl(CharsAndLen))),
  
  %Make Weighted
  WeightedChars = make_weighted_chars(Chars),

  Perms = make_permutations(Chars,Len),
  
  OrderedPerms = order_permutations(Perms,WeightedChars),
  
  lists:foldl( fun(A,Acc) ->
	io:format("~s\n",[A]) end,[],OrderedPerms).

make_permutations(Chars,Depth)->

  Parents = lists:foldl( fun ( A , Acc ) ->
	Acc ++ [node_stuff:regular_node_head(A)]  end, [], Chars),
 
  Leafs = make_permutations_rec(Chars,Depth,1,Parents),

  Vals = lists:foldl( fun ( A , Acc ) ->
	[ node_stuff:read_until_head(A)| Acc] end, [] , Leafs),

  Vals.

make_permutations_rec(Chars,Depth,Count,Outs)->
  if
    Depth == Count -> Outs;
    true ->
      make_permutations_rec(Chars,Depth,Count+1,
      lists:foldl( fun ( A , Acc ) ->
	    lists:merge(Acc, make_leafs(Chars,A)) end, [], Outs))
 end.

make_leafs(Chars,Parent)->
  lists:foldl( fun ( A, Acc)->
	Acc ++ [ node_stuff:regular_node(Parent,A)] end,[],Chars).

make_weighted_chars(Chars)->
  make_weighted_chars_rec(Chars,[],1).

make_weighted_chars_rec(Chars,Outs,Weight)->
  if
    Chars == [] -> Outs;
    true -> make_weighted_chars_rec(tl(Chars),Outs ++ [{hd(Chars),lists:flatten(io_lib:format("~p", [Weight]))}],Weight+1)
  end.

order_permutations(Perms,Weights)->
  WeightDict = dict:from_list(Weights),

  Sorter = fun(X,Y) ->
      XasInts = lists:foldl( fun( A, Acc) ->
	    We = dict:fetch(A,WeightDict),
	    Acc ++ [ dict:fetch(A,WeightDict) ] end,[], X),
      YasInts = lists:foldl( fun( A, Acc) ->
	    Acc ++ [ dict:fetch(A,WeightDict) ] end, [], Y),
      {Xval,Xext} = string:to_integer(lists:flatten(XasInts)),
      {Yval,Yext} = string:to_integer(lists:flatten(YasInts)),
      Xval < Yval end,
  
  lists:sort(Sorter,Perms).
