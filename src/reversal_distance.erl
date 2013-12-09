-module(reversal_distance).

-import(permutation_helper,[make_sized_permutation/2]).
-import(list_helper,[swap_elements/3]).

-export([start/1]).

start(N)->
  %{ok, Data} = file:read_file(N),
  %D = re:replace(Data,"$<<","",[global,{return,list}]),
  %Sets = [ re:split(T,"\n",[{return,list}]) || T <- re:split(D,"\n\n",[{return,list}]) ],
  %find_distance(hd(hd(Sets)),hd(tl(hd(Sets)))).
  io:format("Starting\n",[]),
  Sets = [[["1 2 3"],["2 3 1"]]],
  lists:foldl( fun(A,Acc) ->
    io:format("~w ",[find_distance(hd(A),hd(tl(A)))]) end,[],Sets).

find_distance(Input,Target)->
	%io:format("Input = ~w\n",[Input]),
	%io:format("Target = ~w\n",[Target]),
	ListAInts = lists:foldl( fun(A,Acc) -> 
    	{Val,Ext} = string:to_integer(A),
    	Acc ++ [Val] end,[],string:tokens(hd(Input)," ")),
    ListBInts = lists:foldl( fun(A,Acc) ->
    	{Val,Ext} = string:to_integer(A),
    	Acc ++ [Val] end,[], string:tokens(hd(Target)," ")), 
	%io:format("ListAInts = ~w\n",[ListAInts]),
	find_distance_rec(ListAInts,ListBInts,0).

find_distance_rec(Input,Target,Count)->
	%io:format("Input = ~w\n",[Input]),
	%io:format("Target = ~w\n",[Target]),
	Finished = check_if_finished(Input,Target),
	io:format("Finished = ~w\n",[Finished]),
	if
		Finished == true -> Count;
		true -> 
			NewLists = [ perform_all_swaps(T,Target) || T <- [Input] ],
			io:format("NewLists = ~w\n",[NewLists]),
			find_distance_rec(NewLists,Target,Count+1)
	end.

check_if_finished(Inputs,Target)->
	FoundSolutions = [ Z || Z <- Inputs, check_if_finished_rec(Z,Target) == true ],
	length(FoundSolutions) > 0.

check_if_finished_rec(Input,Target)->
	if
		Input == [] -> true;
		is_list(Input) == false -> Input == Target;
		true->
			A = hd(Input),
			B = hd(Target),
			if
				A == B -> check_if_finished(tl(Input),tl(Target));
				true -> false
			end
	end.

perform_all_swaps(Input,Target)->
	io:format("Inputs = ~w\n",[Input]),
	io:format("Target = ~w\n",[Target]),
	SwappableIndexes = get_swappable_indexes(Input,Target),
	io:format("SwappableIndexes = ~w\n",[SwappableIndexes]),
	SwapPermutations = permutation_helper:make_sized_permutations(SwappableIndexes, 2),
	perform_all_swaps_rec(Input,SwapPermutations,[]).

perform_all_swaps_rec(Input,Indexes,Output)->
	io:format("perfroam_all_swaps_rec\n",[]),
	io:format("Input = ~w\n",[Input]),
	io:format("Indexes = ~w\n",[Indexes]),
	io:format("Output = ~w\n",[Output]),
	if
		Indexes == [] -> Output;
		true ->
			perform_all_swaps_rec(Input,tl(Indexes),
				Output ++ [ list_helper:swap_elements(Input, hd(hd(Indexes)), lists:last(hd(Indexes))) ] )
	end.

get_swappable_indexes(Input,Target)->
	io:format("get_swappable_indexes\n",[]),
	io:format("Input = ~w\n",[Input]),
	io:format("Target = ~w\n",[Target]),
	get_swappable_indexes_rec(Input,Target,1,[]).

get_swappable_indexes_rec(Input,Target,CurrentIndex,Outs)->
	io:format("get_swappable_indexes_rec\n",[]),
	io:format("Input = ~w\n",[Input]),
	io:format("Target = ~w\n",[Target]),
	io:format("Outs  = ~w\n",[Outs]),
	if
		Input == [] -> Outs;
		is_list(Input) == false -> 
			if
				Input == Target -> Outs;
				true -> Outs ++ [CurrentIndex]
			end;
		true->
			X = hd(Input),
			Y = hd(Target),
			if
				Input == [] -> Outs;
				X /= Y -> get_swappable_indexes_rec(tl(Input),tl(Target),CurrentIndex+1,Outs ++ [CurrentIndex]);
				true -> get_swappable_indexes_rec(tl(Input),tl(Target),CurrentIndex+1,Outs)
			end
	end.
