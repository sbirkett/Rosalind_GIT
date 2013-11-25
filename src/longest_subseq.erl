-module(longest_subseq).

-export([start/1]).

start(N)->
  Eles = string:tokens(N," "),
  Ints = convert_to_ints(Eles,[]),
  Dec_Set = longest_dec(Ints),
  Inc_Set = longest_inc(Ints),
  [ Dec_Set , Inc_Set ].

longest_dec(Ll)->
  Rets = longest_dec_rec(Ll,[]),
  %io:format("Rets = ~w\n",[Rets]),
  Sorted_Rets = lists:sort( fun(X,Y) ->length( X) > length( Y) end, Rets),
  %io:format("Sorted_Rets = ~w\n",[Sorted_Rets]),
  hd(Sorted_Rets).

longest_dec_rec(Ll,Outs)->
  if
    Ll == [] -> Outs;
    true -> 
      New_Sets = make_new_sets_dec(Outs,hd(Ll)),
      Pruned_Sets = prune_dec(New_Sets),
      longest_dec_rec(tl(Ll),Pruned_Sets)
  end.

prune_dec(Ll)->
  Ll.



longest_inc(Ll)->
  Rets = longest_inc_rec(Ll,[]),
  Sorted_Rets = lists:sort( fun ( X, Y ) -> length(X) > length(Y) end, Rets),
  hd(Sorted_Rets).

longest_inc_rec(Ll,Outs)->
  if
    Ll == [] -> Outs;
    true ->
      New_Sets = make_new_sets_inc(Outs,hd(Ll)),
      Pruned_Sets = prune_inc(New_Sets),
      longest_inc_rec(tl(Ll),Pruned_Sets)
  end.

prune_inc(Ll)->
  Ll.

make_new_sets_dec(Ll,Val)->
  Update_Lists = [ X ++ [Val] || X <- Ll , 
      lists:last(X) > Val ] ,
    Update_And_Single = [[Val]|Update_Lists],
  %io:format("UpdateLists = ~w\n",[Update_And_Single]),
  lists:merge(Ll ,Update_And_Single).

make_new_sets_inc(Ll,Val)->
  Update_Lists = [ X ++ [Val] || X <- Ll , 
      lists:last(X) < Val ] ,
    Update_And_Single = [[Val]|Update_Lists],
  %io:format("UpdateLists = ~w\n",[Update_And_Single]),
  lists:merge(Ll ,Update_And_Single).

convert_to_ints(Ll,Outs)->
  if
    Ll == [] -> Outs;
    true ->
      {Val,Ext} = string:to_integer(hd(Ll)), 
      convert_to_ints(tl(Ll),Outs ++ [Val])
  end.
