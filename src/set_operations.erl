-module(set_operations).

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/1,set_union/2,set_intersection/2,set_difference/2,set_complement/2]).

solve(File)->
  [ Universe, SetA, SetB ] = read_file(File),
  {ok,FD} = file:open("Output.txt",[write]),
  format_output(FD,set_union(SetA,SetB)),
  format_output(FD,set_intersection(SetA,SetB)),
  format_output(FD,set_difference(SetA,SetB)),
  format_output(FD,set_difference(SetB,SetA)),
  format_output(FD,set_complement(Universe,SetA)),
  format_output(FD,set_complement(Universe,SetB)),
  file:close(FD).

set_union(SetA,SetB)->
  lists:usort(lists:merge(SetA,SetB)).

set_intersection(SetA,SetB)->
  lists:sort(
    lists:foldl( fun(A,Acc) ->
      case lists:member(A,SetB) of
	  	true -> [ A | Acc ] ;
		  false -> Acc 
	  end 
	  end,[],SetA)
  ).

set_difference(SetA,SetB)->
  lists:sort(
	lists:foldl( fun(A,Acc)->
	  case lists:member(A,SetB) of
	    true -> Acc;
		false -> [A | Acc ]
	  end
	  end, [], SetA)
  ).

set_complement(Universe,SetA)->
  lists:sort(
	lists:foldl( fun(A,Acc) ->
	  case lists:member(A,SetA) of
	    true -> Acc;
		false -> [ A | Acc ]
	  end
	  end, [], Universe)
  ).

%% ====================================================================
%% Internal functions
%% ====================================================================

format_output(FD,List)->
  io:format(FD,"{",[]),
  lists:map( fun (A) -> 
	io:format(FD,"~w, ",[A]) end,
	lists:sublist(List,length(List) -1 )),
  io:format(FD,"~w}\n",[lists:last(List)]).

read_file(File)->
  {ok,Data} = file:read_file(File),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,"\n"),
  {Universe,_Rest} = string:to_integer(hd(T)),
  
  [ lists:seq(1,Universe) , 
	lists:foldl(
	  fun(A,Acc) -> 
	    {Int,_} = string:to_integer(A),
		case Int of
		  error -> Acc;
		  _ -> [ Int | Acc ]
		end
	  end,
	  [], 
	  string:tokens(
		lists:sublist(
		  lists:nth(2,T),2,length(lists:nth(2,T))-2),", ")) ,
	lists:foldl(
	  fun(A,Acc) -> 
	    {Int,_} = string:to_integer(A),
		case Int of
		  error -> Acc;
		  _ -> [ Int | Acc ]
		end
	  end,
	  [], 
	  string:tokens(
		lists:sublist(
		  lists:nth(3,T),2,length(lists:nth(3,T))-2),", ")) ].
