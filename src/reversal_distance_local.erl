-module(reversal_distance_local).

-import(permutation_helper,[make_sized_permutation/2]).

-compile("../helpers.erl").
-compile("list_helper.erl").

-import(helpers,[index_of/2]).
-import(list_helper,[swap_elements/3]).

-export([start/1]). 
 
start(N)->
  %{ok, Data} = file:read_file(N),
  %D = re:replace(Data,"$<<","",[global,{return,list}]),
  %Sets = [ re:split(T,"\n",[{return,list}]) || T <- re:split(D,"\n\n",[{return,list}]) ],
  %find_distance(hd(hd(Sets)),hd(tl(hd(Sets)))).
  %io:format("Starting\n",[]),
  Sets = [[["3 10 8 2 5 4 7 1 6 9"],["5 2 3 1 7 4 10 8 6 9"]]],
  %Sets = [[["8 6 7 9 4 1 3 10 2 5"],["8 2 7 6 9 1 5 3 10 4"]]],
  %Sets = [[["1 2 3 4 5 6 7 8 9 10"],["1 2 3 4 5 6 7 8 9 10"]]],
  %Sets = N,
  %io:format("Sets = ~w\n",[Sets]),
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
  find_distance_rec([ListAInts],ListBInts,0).

find_distance_rec(Input,Target,Count)->
	%io:format("Input = ~w\n",[Input]),
	%io:format("Target = ~w\n",[Target]),
	Finished = check_if_finished(Input,Target),
	%io:format("Finished = ~w\n",[Finished]),
	if
		Finished == true -> Count;
		Count > length(Input) -> "FAILED";
		true -> 
			
			NewLists = %[ perform_all_swaps(T,Target) || T <- Input ],
			  lists:foldl( fun(A,Acc) ->
			    lists:merge(Acc,perform_all_swaps(A,Target)) end,[],Input),
                        LessNewLists = sets:to_list(sets:from_list(NewLists)),
			find_distance_rec(LessNewLists,Target,Count+1)
	end.

check_if_finished(Inputs,Target)->
	%io:format("check_if_finished\n",[]),
	%io:format("Inputs = ~w\n",[Inputs]),
	%io:format("Target = ~w\n",[Target]),
	FoundSolutions = [ Z || Z <- Inputs, check_if_finished_rec(Z,Target) == true ],
	length(FoundSolutions) > 0.

check_if_finished_rec(Input,Target)->
  %io:format("check_if_finished_rec\n",[]),
  %io:format("Input = ~w\n",[Input]),
  %io:format("Target = ~w\n",[Target]),
	if
		Input == [] -> true;
		is_list(Input) == false -> 
			Input == Target;
		true->
			A = hd(Input),
			B = hd(Target),
			if
				A == B -> check_if_finished_rec(tl(Input),tl(Target));
 				true -> false
			end
	end.

perform_all_swaps(Input,Target)->
  %io:format("Perform_all_swaps\n",[]),
  %io:format("Input = ~w\n",[Input]),
  %io:format("Target = ~w\n",[Target]),
  SwappableIndexes = get_swappable_indexes(Input,Target),
  LessSwappableIndexes = sets:to_list(sets:from_list( [ lists:usort(T) || T <- SwappableIndexes ])),
  lists:foldl( fun(A,Acc) ->
    Acc ++ [ list_helper:swap_elements(Input,hd(A),lists:last(A))] end ,[],LessSwappableIndexes).

perform_all_swaps_rec(Input,Indexes,Output)->
	if
		Indexes == [] -> Output;
		true ->
			perform_all_swaps_rec(Input,tl(Indexes),
				%Output ++ [perform_swap(Input,lists:sort(hd(Indexes)))] )
				Output ++ [ list_helper:swap_elements(Input,hd(hd(Indexes)),lists:last(hd(Indexes)))])
	end.

get_swappable_indexes(Input,Target)->
  new_get_swappable_indexes(Input,Target,1,[]).

new_get_swappable_indexes(Input,Target,CurrentIndex,Outs)->
  %io:format("new_get_swappable_indexes\n",[]),
  %io:format("Input = ~w\n",[Input]),
  %io:format("Target = ~w\n",[Target]),
  %io:format("CI = ~w\n",[CurrentIndex]),
  %io:format("Outs = ~w\n",[Outs]),

  if
    (CurrentIndex-1) == length(Input) -> Outs;
    true -> 
      A = lists:nth(CurrentIndex,Input),
      B = lists:nth(CurrentIndex,Target),
      if
        A == B -> new_get_swappable_indexes(Input,Target,CurrentIndex+1,Outs);
        true ->
          new_get_swappable_indexes(Input,Target,CurrentIndex+1,[[CurrentIndex,helpers:index_of(A,Target)]|Outs])
      end
  end.

new_get_swappable_indexes_val(Val,Target,CurrentIndex)->
  if
    Val == hd(Target) -> CurrentIndex;
    true -> 
      new_get_swappable_indexes_val(Val,tl(Target),CurrentIndex)
  end.