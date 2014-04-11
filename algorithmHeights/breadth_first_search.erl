%% @author birketsc
%% @doc @todo Add description to breadth_first_search.

-module(breadth_first_search).

-import(graph_helpers,[directed_read_edge_list_file/1,graph_as_dict/1]).

-include_lib("alg_nodes.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/1,find_distance/3]).

solve(File)->
	
  compile:file("graph_helpers.erl"),
  
  GraphDict = 
	  graph_helpers:graph_as_dict(
		graph_helpers:directed_read_edge_list_file(File)),
  
  lists:map(
	fun(A)->
	  io:format(
		"~w ",
		[find_distance(
		   dict:fetch(1,GraphDict),
		   dict:fetch(A,GraphDict),
		   GraphDict)]) 
	end,
	lists:seq(1,dict:size(GraphDict))).

find_distance(NodeS,NodeT,Graph)->
  case NodeS#node.ident == NodeT#node.ident of
	  true -> 0;
	  false ->
          find_distance_rec(
                NodeT,
                Graph,
                NodeS#node.connections,
                [[NodeS#node.ident]])
  end.

%% ====================================================================
%% Internal functions
%% ====================================================================

find_distance_rec(_,_,[],_)-> -1;
find_distance_rec(T,Graph,NeighborKeys,VisitedKeys)->

  case lists:member(T#node.ident,NeighborKeys) of
	true -> length(VisitedKeys);
	false -> 
	  NewVisitedKeys = [ NeighborKeys | VisitedKeys ],
	  
	  AllNeighborNeighbors =
		lists:filter(
		  fun(A)->
		    lists:all(
			  fun(B)->
			    not lists:member(A,B) end,NewVisitedKeys)
		  end,
	      lists:usort(
		    lists:foldl(
		      fun(A,Acc)->
		        Node = dict:fetch(A, Graph),
			    lists:merge(Acc,Node#node.connections)
		      end,[],NeighborKeys))),
	  
	  find_distance_rec(T,Graph,AllNeighborNeighbors,NewVisitedKeys)
  end.