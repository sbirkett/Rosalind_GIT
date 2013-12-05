-module(reversal_distance).

-export([start/1]).

start(N)->
  {ok, Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  Sets = [ re:split(T,"\n",[{return,list}]) || T <- re:split(D,"\n\n",[{return,list}]) ],
  %find_distance(hd(hd(Sets)),hd(tl(hd(Sets)))).
  lists:foldl( fun(A,Acc) ->
    io:format("~w ",[find_distance(hd(A),hd(tl(A)))]) end,[],Sets).

find_distance(ListA,ListB)->
  ListAInts = lists:foldl( fun(A,Acc) -> 
    {Val,Ext} = string:to_integer(A),
    Acc ++ [Val] end,[],string:tokens(ListA," ")),
  ListBInts = lists:foldl( fun(A,Acc) ->
    {Val,Ext} = string:to_integer(A),
    Acc ++ [Val] end,[], string:tokens(ListB," ")), 
  find_distance_rec(ListAInts,ListBInts,0,1).

find_distance_rec(ListA,ListB,Reversals,Index)->
  io:format("ListA = ~w\n",[ListA]),
  io:format("ListB = ~w\n",[ListB]),
  LengA = length(ListA),
  if
    Index == LengA -> Reversals;
    true ->
      A = lists:nth(Index,ListA),
      B = lists:nth(Index,ListB),
      
      io:format("A = ~w\n",[A]),
      io:format("B = ~w\n",[B]),
      if
        A == B -> find_distance_rec(ListA,ListB,Reversals,Index+1);
        true ->
          io:format("Doing swap\n",[]),
          NewListA = perform_reversal(ListA,A,B),
          find_distance_rec(NewListA,ListB,Reversals+1,Index+1)
      end
  end.
      
perform_reversal(ListA,AVal,BVal)->
  lists:foldl( fun (A , Acc ) ->
    if 
      A == AVal -> Acc ++ [BVal];
      A == BVal -> Acc ++ [AVal];
      true -> Acc ++ [A]
    end end,[],ListA).

index_of(Item, List) -> index_of(Item, List, 1).

index_of(_, [], _)  -> not_found;
index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).
