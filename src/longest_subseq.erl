-module(longest_subseq).

-export([start/1]).

start(N)->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  Eles = string:tokens(D," "),
  Ints = convert_to_ints(Eles,[]),
  Dec_Dict_Set = longest_dec_dict(Ints),
  Inc_Set = longest_inc_dict(Ints),

  lists:foldl( fun (A,Acc)->
	io:format("~w ",[A]) end,[],
    hd(lists:sort( fun(X,Y) -> length(X) > length(Y) end, Inc_Set))),

  io:format("\n",[]),
  
  lists:foldl(fun (A, Acc)->
	io:format("~w ",[A]) end,[],
    hd(lists:sort( fun(X,Y) -> length(X) > length(Y) end, Dec_Dict_Set))),	
  
  io:format("\n",[]).

longest_inc_dict(Ll)->
  Outs = longest_inc_dict_rec(Ll,dict:new()),
  [ element(2,Z) || Z <- dict:to_list(Outs) ].

longest_inc_dict_rec(Ll,Outs)->
  if
    Ll == [] -> Outs;
    true -> 
      New_Sets = make_new_dicts_inc(Outs,hd(Ll)),
      Pruned_Sets = prune_dicts_inc(New_Sets,Outs),
      longest_inc_dict_rec(tl(Ll),Pruned_Sets)
  end.

prune_dicts_inc(NewDict,OldDict)->
  dict:merge( fun (Key, A ,B ) ->
	LastA = lists:last(A),
        LastB = lists:last(B),
        if
	  LastA > LastB -> B;
	  true -> A
	 end 
     end,NewDict,OldDict).

make_new_dicts_inc(Ll,Val)->
  Starter = [{1,[Val]}],
  Old = dict:to_list(Ll),
  OldWithMore = lists:foldl( fun ( A , Acc ) ->
	Lis = element(2,A),
	LastLis = lists:last(Lis),
	if
	  LastLis < Val -> 
	    [ { length(Lis) + 1, Lis ++ [Val] } | Acc ];
	  true -> 
	    [ A | Acc ] 
	end
    end, [], Old),
  All = lists:merge(Starter,OldWithMore),
  
  lists:foldl( fun( A,Acc )->
	ISKEY = dict:is_key(element(1,A),Acc),
	if
	  ISKEY == true -> 
	    LasIn = lists:last(dict:fetch(element(1,A),Acc)),
	    May = LasIn > lists:last(element(2,A)),
	   if
	      May == false ->
		Acc;
	      true ->
		dict:store(element(1,A),element(2,A),Acc)
	    end;
	  true -> dict:store(element(1,A),element(2,A),Acc)
	end
    end,dict:new(),All).

longest_dec_dict(Ll)->
  Outs = longest_dec_dict_rec(Ll,dict:new()),
  [ element(2,Z) || Z <- dict:to_list(Outs) ].

longest_dec_dict_rec(Ll,Outs)->
  if
    Ll == [] -> Outs;
    true -> 
      New_Sets = make_new_dicts_dec(Outs,hd(Ll)),
      Pruned_Sets = prune_dicts_dec(New_Sets,Outs),
      longest_dec_dict_rec(tl(Ll),Pruned_Sets)
  end.

prune_dicts_dec(NewDict,OldDict)->
  dict:merge( fun (Key, A ,B ) ->
	LastA = lists:last(A),
        LastB = lists:last(B),
        if
	  LastA < LastB -> B;
	  true -> A
	 end 
     end,NewDict,OldDict).

make_new_dicts_dec(Ll,Val)->
  Starter = [{1,[Val]}],
  Old = dict:to_list(Ll),
  OldWithMore = lists:foldl( fun ( A , Acc ) ->
	Lis = element(2,A),
	LastLis = lists:last(Lis),
	if
	  LastLis > Val -> 
	    [ { length(Lis) + 1, Lis ++ [Val] } | Acc ];
	  true -> 
	    [ A | Acc ] 
	end
    end, [], Old),
  All = lists:merge(Starter,OldWithMore),
  
  lists:foldl( fun( A,Acc )->
	ISKEY = dict:is_key(element(1,A),Acc),
	if
	  ISKEY == true -> 
	    LasIn = lists:last(dict:fetch(element(1,A),Acc)),
	    May = LasIn < lists:last(element(2,A)),
	   if
	      May == false ->
		Acc;
	      true ->
		dict:store(element(1,A),element(2,A),Acc)
	    end;
	  true -> dict:store(element(1,A),element(2,A),Acc)
	end
    end,dict:new(),All).

convert_to_ints(Ll,Outs)->
  if
    Ll == [] -> Outs;
    true ->
      {Val,Ext} = string:to_integer(hd(Ll)), 
      convert_to_ints(tl(Ll),Outs ++ [Val])
  end.
