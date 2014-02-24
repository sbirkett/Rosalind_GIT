-module(catalan_numbers).

-record(node,{value,ind,nxt}).

-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).

-export([solve/1]).

solve(File)->
  compile:file("../fasta_reader.erl"),
  Fasta = hd(fasta_reader:read(File)),
  Seq = Fasta#fasta.sequence,

  % Make nodes
  Nodes = lists:foldl( fun (A,Acc) ->
	Acc ++ [ 
	  #node{
	    value = A,
	    ind = length(Acc) + 1,
	    nxt = 0} ] end
	,[],Seq),
  outside_check(Nodes).

% Make base start
% All Graphs made from connecting edges that connect over an
% outer span of 2*(k)
make_base_set(Nodes)->
  FreeNodes = [ X || X <- Nodes, X#node.nxt == 0 ].

% Construct all the possible sub graphs
make_valid_sub_graphs(Nodes)->
  1.

% Check outside edges scenario
% Two possible.
outside_check(Nodes)->
  NodeDict = dict:from_list([ { A#node.ind, A } || A <- Nodes ]),
  EvenToOdd = dict:fold( fun(K,A,Acc) ->
	case ( K rem 2 ) of
	  1 -> 
	    NextNode = get_next_elem(K,NodeDict),
	    case valid_connection( A#node.value , NextNode#node.value ) of
	      true -> lists:merge(Acc,assign_edge(A,NextNode));
	      false -> lists:merge(Acc, [A,NextNode])
	    end;
	  _ ->
	    Acc
	end end,[],NodeDict),
  OddToEven = dict:fold( fun(K,A,Acc) ->
	case ( K rem 2 ) of
	  0 ->
	    NextNode=  get_next_elem(K,NodeDict),
	    case valid_connection(A#node.value, NextNode#node.value) of 
	      true -> lists:merge(Acc,assign_edge(A,NextNode));
	      false -> lists:merge(Acc, [A,NextNode])
	    end;
	  _ ->
	    Acc
	end end,[],NodeDict),

  %io:format("~w\n~w\n",[EvenToOdd,OddToEven]),
  case {check_complete(EvenToOdd),check_complete(OddToEven)} of
    {true,true} -> 2;
    {true,false} ->1;
    {false,true} ->1;
    {false,false} ->0
  end.


% Check if graph complete
check_complete(Nodes)->
  % All Nodes have connections
  EmptyNodes = lists:filter( fun (A) -> A#node.nxt == 0 end, Nodes),
  %io:format("EmptyNodes = ~w\n",[EmptyNodes]),
  case length(EmptyNodes) of 
    0 ->
      check_edges(Nodes,[]);
    _ ->
      false
  end.

% Intersecting Edges 
check_edges([],_)->true;
check_edges([Node|Nodes],[])-> check_edges(Nodes,[Node]);
check_edges([Node|Nodes],CheckedNodes)->
  %io:format("Node = ~w\n",[Node]),
  %io:format("CheckedNodes = ~w\n",[CheckedNodes]),
  Conflicts = lists:filter( fun(A) -> 
	( A#node.nxt /= Node#node.ind )
	and
	do_valid_checking(A,Node)
        end, CheckedNodes),
  %io:format("Conflicts = ~w\n",[Conflicts]),
  case length(Conflicts) of
    0 -> check_edges(Nodes,[Node|CheckedNodes]);
    _ -> false
  end.

do_valid_checking(A,B)->
  {X,Y} = 
  	case A#node.ind > B#node.ind of
	  true -> {B,A};
	  false -> {A,B}
	end,
  
  catch_one(X,Y) or 
  catch_two(X,Y) or 
  catch_three(X,Y) or
  catch_four(X,Y).

% --- A --- BT --- AT --- B ---
catch_one(A,B)->
  case A#node.ind < B#node.ind of
    false -> false;
    true ->
      case A#node.nxt < B#node.ind of
	false -> false;
	true ->
	  case ( A#node.nxt > B#node.nxt ) and ( A#node.ind < B#node.nxt) of
	    false -> false;
	   true -> true
	 end
     end
 end. 

% --- AT --- BT --- A --- B ---
catch_two(A,B)->
  case A#node.ind < B#node.ind of 
    false -> false;
    true ->
      case (A#node.nxt < A#node.ind) and (B#node.nxt < A#node.ind) of
	false -> false;
	true -> 
	  case (A#node.nxt < B#node.nxt) of
	    false -> false;
	    true -> true
	end
     end
  end.


% --- BT --- A --- B --- AT ---
catch_three(A,B)->
  case A#node.ind < B#node.ind of
    false -> false;
    true ->
      case (A#node.nxt > B#node.ind) and (B#node.nxt < A#node.ind) of
	false -> false;
	true -> true
      end
  end.

% --- A --- B --- AT --- BT ---
catch_four(A,B)->
  case A#node.ind < B#node.ind of 
    false -> false;
    true ->
      case (A#node.nxt > B#node.ind) and ( B#node.nxt > B#node.ind ) of
	false -> false;
	true ->
	  case A#node.nxt < B#node.nxt of
	    false -> false;
	    true -> true
	  end
      end
  end.

valid_connection(A,B)->
  case {A,B} of 
    {65,85} -> true;
    {85,65} -> true; 
    {67,71} -> true; 
    {71,67} -> true; 
    {_,_} -> false
  end.

get_next_elem(CurrKey,Dict)->
  case ( dict:size(Dict) == CurrKey ) of
    true -> dict:fetch(1,Dict);
    false -> dict:fetch(CurrKey+1,Dict)
  end.

assign_edge(A,B)->
  AMod = #node { value = A#node.value, ind = A#node.ind, nxt = B#node.ind },
  BMod = #node { value = B#node.value, ind = B#node.ind, nxt = A#node.ind },
  [AMod,BMod].
