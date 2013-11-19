-module(longest_subseq).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1]).


start(N)->
	Elems = input_to_list(N),
	
	Longest_Increasing = find_increasing(Elems,[]),
	
	Longest_Increasing.

%% ====================================================================
%% Internal functions
%% ====================================================================

find_increasing(Input,Output)->
	
	First_Ele = [[hd(Input)]],
	
	find_increasing_rec(tl(Input),First_Ele).

find_increasing_rec(Input,Output)->
	io:format("Input ~w\n",[Input]),
	io:format("Output ~w\n",[Output]),
	if
		Input == [] -> Output;
		true -> 
			find_increasing_rec(tl(Input),add_where_applicable_increasing(hd(Input),Output))
	end.
			

add_where_applicable_increasing(Val,Lis)->
	io:format("Val ~w\n",[Val]),
	io:format("Lis ~w\n",[Lis]),
	Outs = lists:foldl( fun( X, Acc ) -> 
						io:format("X = ~w\n",[X]),
						io:format("Acc = ~w\n",[Acc]),
						Last_Ele = lists:last(X), 
						io:format("Last_Ele ~w\n",[Last_Ele]),
						if 
							Last_Ele < Val -> Acc ++ Lis ++ Val;
							true -> Acc 
						end 
				 end,[[Val]],Lis),
	Outs.

prune_increasing(Input)->
	1.

input_to_list(N)->
	Eles = string:tokens(N," "),
	Eles_As_Ints = 
		lists:foldr( fun ( X , Acc ) ->
							  {Z,_rest} = string:to_integer(X),
							  [Z|Acc] end,[],Eles),
	Eles_As_Ints.