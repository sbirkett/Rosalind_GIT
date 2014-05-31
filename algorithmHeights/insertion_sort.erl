-module(insertion_sort).

-export([sort_with_count/1]).

%%%%% Contract %%%%%
sort_with_count(File) ->

 Vals = read_file(File),
 sort_and_count(2,Vals,0).

%%%%% Internal %%%%%

sort_and_count(Index,Vals,Swaps) ->

  case Index == dict:size(Vals) + 1 of
    false -> 
      {NewVals,NewSwaps} = shift_and_count(Index,Vals,Swaps),
      sort_and_count(Index+1,NewVals,NewSwaps);
    true -> Swaps
  end.

shift_and_count(1,Vals,Swaps) -> {Vals,Swaps};
shift_and_count(TokenIndex,Vals,Swaps)->

  Token = dict:fetch(TokenIndex,Vals),
  BeforeToken = dict:fetch(TokenIndex-1,Vals),

  case Token < BeforeToken of
    false -> {Vals,Swaps};
    true ->
      FirstMod = dict:store(TokenIndex-1,Token,Vals),
      SecondMod = dict:store(TokenIndex,BeforeToken,FirstMod),
      shift_and_count(TokenIndex-1,SecondMod,Swaps+1)
  end.

read_file(File) ->
  {ok,Data} = file:read_file(File),

  D = re:replace(Data,"$<<","",[global,{return,list}]),

  DSegments = 
    case os:type() of
      {unix,_} ->
	re:split(D,"\n",[{return,list}]);
      _ ->
	re:split(D,"\r\n",[{return,list}])
    end,
  
  Vals = hd(tl(DSegments)),

  lists:foldl(
    fun(A,Acc) ->
	dict:store(dict:size(Acc) + 1, A, Acc) end,
    dict:new(),
    [ element(1,string:to_integer(T)) || T <- re:split(Vals," ",[{return,list}]) ]).
