-module(reversal_distance).

-import(permutation_helper,[make_sized_permutation/2]).

-export([start/1]).

start(N)->
  %{ok, Data} = file:read_file(N),
  %D = re:replace(Data,"$<<","",[global,{return,list}]),
  %Sets = [ re:split(T,"\n",[{return,list}]) || T <- re:split(D,"\n\n",[{return,list}]) ],
  %find_distance(hd(hd(Sets)),hd(tl(hd(Sets)))).
  io:format("Starting\n",[]),
  Sets = [["1 2"],["2 1"]],
  lists:foldl( fun(A,Acc) ->
    io:format("~w ",[find_distance(hd(A),hd(tl(A)))]) end,[],Sets).

find_distance(Input,Target)->
	io:format("Input = ~w\n",[Input]),
	io:format("Target = ~w\n",[Target]),
	ListAInts = lists:foldl( fun(A,Acc) -> 
    	{Val,Ext} = string:to_integer(A),
    	Acc ++ [Val] end,[],string:tokens(Input," ")),
    ListBInts = lists:foldl( fun(A,Acc) ->
    	{Val,Ext} = string:to_integer(A),
    	Acc ++ [Val] end,[], string:tokens(Target," ")), 
	io:format("ListAInts = ~w\n",[ListAInts]),
	find_distance_rec(ListAInts,ListBInts,0).

find_distance_rec(Input,Target,Count)->
	io:format("Input = ~w\n",[Input]),
	io:format("Target = ~w\n",[Target]),
	Finished = check_if_finished(Input,Target),
	io:format("Finished = ~w\n",[Finished]),
	if
		Finished == true -> Count;
		true -> 
			NewLists = [ perform_all_swaps(T,Target) || T <- Input ],
			find_distance_rec(NewLists,Target,Count+1)
	end.

check_if_finished(Inputs,Target)->
	io:format("Inputs = ~w\n",[Inputs]),
	io:format("Target = ~w\n",[Target]),
	FoundSolutions = [ Z || Z <- Inputs, check_if_finished_rec(Z,Target) == true ],
	length(FoundSolutions) > 0.

check_if_finished_rec(Input,Target)->
	if
		Input == [] -> true;
		true->
			A = hd(Input),
			B = hd(Target),
			if
				A == B -> check_if_finished(tl(Input),tl(Target));
				true -> false
			end
	end.

perform_all_swaps(Input,Target)->
	SwappableIndexes = get_swappable_indexes(Input,Target),
	SwapPermutations = permutation_helper:make_sized_permutations(SwappableIndexes, 2),
	perform_all_swaps_rec(Input,SwapPermutations,[]).

perform_all_swaps_rec(Input,Indexes,Output)->
	if
		Indexes == [] -> Output;
		true ->
			perform_all_swaps_rec(Input,tl(Indexes),
				Output ++ [ perform_swap(Input,lists:sort(hd(Indexes)))] )
	end.

get_swappable_indexes(Input,Target)->
	get_swappable_indexes_rec(Input,Target,1,[]).

get_swappable_indexes_rec(Input,Target,CurrentIndex,Outs)->
	X = hd(Input),
	Y = hd(Target),
		if
			Input == [] -> Outs;
			X == Y -> get_swappable_indexes_rec(tl(Input),tl(Target),CurrentIndex+1,Outs ++ [CurrentIndex]);
			true -> get_swappable_indexes_rec(tl(Input),tl(Target),CurrentIndex+1,Outs)
		end.

perform_swap(Input,Indexes)->
	FirstIndex = hd(Indexes),
	SecondIndex = lists:last(Indexes),
	FirstSection = lists:sublist(Input, FirstIndex-1),
	MiddleSection = lists:sublist(Input, FirstIndex+1, SecondIndex-1),
	LastSection = lists:nthtail(SecondIndex+1, Input),
	NewList = FirstSection ++ [lists:nth(SecondIndex,Input)] ++ MiddleSection
		++ [lists:nth(SecondIndex,Input)] ++ LastSection,
	NewList.
