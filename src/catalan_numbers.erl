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
  All_Graphs = make_graphs(1,length(Nodes),[Nodes]),
  lists:foldl( fun ( A , Acc ) ->
    case check_complete(A) of
      {true,true} -> Acc + 1;
	  {_,_} -> Acc
	end
    end,0,All_Graphs).
  
make_graphs(Start,Max,Graphs) ->
  %io:format("Graphs = ~w\n",[Graphs]),
  case Start == Max of
    true -> Graphs;
    false ->
      make_graphs(
		Start+1, 
		Max,
	    lists:foldl( fun (A,Acc) ->
	      case check_complete(A) of
		    {false,true} -> 
				%io:format("was {false,true}\n"),
				lists:merge(Acc,make_all_forward_graphs(A,Start));
		    {true,true} -> 
				%io:format("was { true,true }\n"),
				[ A | Acc ];
			{true,false} ->
				%io:format("was { true, false}\n"),
				Acc;
		    {_,_} ->
				%io:format("was { false,false}\n"),
				Acc
	      end
	      end, [], Graphs))
  end.

% Make All Forward Edged Graphs
% from lowest index free node
make_all_forward_graphs(Nodes,IndexInQ)->
  %io:format("make_all_forward_graphs\n",[]),
  %io:format("Nodes = ~w\n",[Nodes]),
  First = hd([ X || X <- Nodes, X#node.nxt == 0 ]),
  %io:format("IndexInQ = ~w\n",[IndexInQ]),
  if 
    First#node.ind == IndexInQ ->
      lists:foldl( fun ( A , Acc ) ->
  	    case ( A#node.ind > First#node.ind ) of
	 	  true ->
            case validate_connection(A,First,Nodes) of
	          false ->
		    Acc;
              true -> 
	        [ assign_edge(First,A,Nodes) | Acc ]
	      end;
        false -> Acc
      end
      end,[],Nodes);
	First#node.ind < IndexInQ -> [];
    true -> [ Nodes ]
  end.
	
% Check if graph complete
check_complete(Nodes)->
  %io:format("check_compelte\n"),
  %io:format("Nodes = ~w\n",[Nodes]),
  EmptyNodes = lists:filter( fun (A) -> A#node.nxt == 0 end, Nodes),
  case length(EmptyNodes) of 
    0 ->
      {true,check_edges(Nodes,[])};
    _ ->
      {false,check_edges(Nodes,[])}
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
  %io:format("Node = ~w\n",[Node]),
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
  C1 = catch_one(X,Y),
  C2 = catch_two(X,Y),
  C3 = catch_three(X,Y),
  C4 = catch_four(X,Y),
  if
    A#node.nxt == 0 -> false;
    A#node.nxt == B#node.ind -> false;
    B#node.nxt == 0 -> false;
    B#node.nxt == A#node.ind -> false;
    C1 -> true;
    C2 -> true;
    C3 -> true;
    C4 -> true;
    true -> false
  end.

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

validate_connection(A,B,Nodes)->
  valid_connection(A,B) and valid_span(A,B,Nodes).

valid_span(A,B,Nodes)->
  NodesBetween = 
    lists:filter( fun ( Z ) ->
	    ( Z#node.ind > A#node.ind ) 
		  and
		( Z#node.ind < B#node.ind )
	  end,Nodes),
  CharDict = char_counts(NodesBetween,dict:from_list([{65,0},{67,0},{71,0},{85,0}])),
  ACount = dict:fetch(65,CharDict),
  CCount = dict:fetch(67,CharDict),
  GCount = dict:fetch(71,CharDict),
  UCount = dict:fetch(85,CharDict),
  if 
    NodesBetween == [] -> true;
	((ACount == UCount) and (CCount == GCount)) -> true;
	true -> false
  end.

valid_connection(#node{nxt=ANxt},#node{nxt=BNxt}) 
  when ( ( ANxt > 0 ) or ( BNxt > 0) ) -> false;
valid_connection(#node{value=AValue},#node{value=BValue})->
  case {AValue,BValue} of 
    {65,85} -> true;
    {85,65} -> true; 
    {67,71} -> true; 
    {71,67} -> true; 
    {_,_} -> false
  end.

char_counts([],Outs) -> Outs;
char_counts([Node,Nodes],Outs)->
  char_counts(Nodes,dict:update(Node#node.value, fun(A) -> A + 1 end, 1, Outs)).

assign_edge(X,Y,Nodes)->
  lists:foldl( fun (A ,Acc)->
    if
      A#node.ind == X#node.ind -> 
	    Acc ++ [ #node { value = A#node.value , ind = A#node.ind, nxt = Y#node.ind } ];
      A#node.ind == Y#node.ind -> 
	    Acc ++ [ #node { value = A#node.value , ind = A#node.ind, nxt = X#node.ind } ];
      true -> 
        Acc ++ [ A ]
    end
    end, [], Nodes).
