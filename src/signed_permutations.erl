-module(signed_permutations).

-export([start/1]).

start(N)->
	
  {X,_rest} = string:to_integer(N),
  
  Z = make_list_of_lists(X,1,[]),

  T = make_end_func(hd(Z)),

  Fs = make_funcs(T,tl(Z)),

  Vals = Fs([]),
  
  AllPermSets = [ perms( lists:sublist(Li,length(Li)-1)) || Li <- Vals],
	
  AllPerms = lists:foldl( fun( Li , Acc ) ->
								  lists:merge(Acc,Li)
								  end, [], AllPermSets),
  
  io:format("~w\n",[length(AllPerms)]),
  
  lists:foldl( fun( Li, Acc ) ->
					   lists:foldl( fun ( InnerEle, InnerAcc ) ->
											 io:format("~w ",[InnerEle]) end, [], Li),
			           io:format("\n",[])
	  			       end, [], AllPerms).

make_funcs(PreviousFunc,List)->
  if
    List == [] -> PreviousFunc;
    true -> 
      ThisFunc = make_non_end_func(hd(List),PreviousFunc),
      make_funcs(ThisFunc,tl(List))
  end.

make_non_end_func(List,NextFunc)->

  fun ( X ) ->

    Subs = [ NextFunc(T) || T <- List ],

    FirstSet = hd(Subs),
    SecondSet = hd(tl(Subs)),

    First = [  Z ++ [X]  || Z <- FirstSet ],

    Second = [  Z ++ [X]  || Z <- SecondSet ],

    lists:merge(First,Second) end.

make_end_func(List) ->
  fun ( X ) -> 
    [ [ Y | [X] ]  || Y <- List ] end.

make_list_of_lists(N,ToAdd,Ret)->
  if 
    N == ToAdd -> [ [ ToAdd, (ToAdd * (-1)) ] | Ret ];
    true -> make_list_of_lists(N,ToAdd + 1,[ [ ToAdd, (ToAdd * (-1)) ] | Ret ])
  end.
 
perms([])-> 
	[[]];

perms(L)-> 
	[[H|T] || H <- L, T <- perms(L--[H])].
