%% @author birketsc
%% @doc @todo Add description to connected_components.

-module(connected_components).

-import(graph_helpers,[read_edge_list_file/1,graph_as_dict/1]).

-include_lib("alg_nodes.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/1,get_connected_sub_graphs/1]).

solve(File)->
	
  compile:file("graph_helpers.erl"),
  
  Nodes = graph_helpers:read_edge_list_file(File),
  
  Graphs = get_connected_sub_graphs(Nodes),
  
  io:format("~w\n",[length(Graphs)]).

get_connected_sub_graphs(Graph)->
	
  rec_get_connected_sub_graphs(
	Graph,
	graph_helpers:graph_as_dict(Graph),
	[]).

%% ====================================================================
%% Internal functions
%% ====================================================================

rec_get_connected_sub_graphs([],_,Outs)->Outs;
rec_get_connected_sub_graphs(Nodes,NodesDict,Outs)->
	
  NodeInQ = hd(Nodes),
  
  NeighborsInQAsDict = 
		gather_all_neighbors(
		  [NodeInQ],NodesDict,dict:new()),
  
  RemainingNodes =
    lists:foldl(
	  fun(A,Acc)->
	    case dict:is_key(A#node.ident,NeighborsInQAsDict) of
		  true -> Acc;
		  false -> [ A | Acc ]
		end
	  end,
	  [],
	  Nodes),
  
  rec_get_connected_sub_graphs(
	RemainingNodes,
	NodesDict,
	[ NeighborsInQAsDict | Outs ]).

gather_all_neighbors([],_,OutsDict)-> OutsDict;
gather_all_neighbors(Nodes,NodesDict,OutsDict)->
	
  NodeInQ = hd(Nodes),

  NodesAsDict = 
	  graph_helpers:graph_as_dict(
		lists:delete(NodeInQ,Nodes)),
  
  Neighbors = 
    [ dict:fetch(T,NodesDict) 
		|| 
      T <- NodeInQ#node.connections, 
	  not 
	    ( dict:is_key(T,OutsDict) or dict:is_key(T, NodesAsDict) ) ],
  
  gather_all_neighbors(
    lists:merge(lists:delete(NodeInQ, Nodes),Neighbors),
    NodesDict,
	dict:append(NodeInQ#node.ident,NodeInQ,OutsDict)).