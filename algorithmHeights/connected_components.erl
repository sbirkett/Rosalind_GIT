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
	
  io:format("rec_get_connect_sub_graphs\n"),
  % Gather first node
  NodeInQ = hd(Nodes),
  io:format("nod in q = ~w\n",[NodeInQ]),
  % Recursively find all the neighbors
  NeighborsInQAsDict = 
	 % graph_helpers:graph_as_dict( 
		gather_all_neighbors(
		  Nodes,NodesDict,dict:new()),
  
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
  
  %io:format("RemaningNodes = ~w\n",[RemainingNodes]),
  
  %RemainingNodes =
	%  lists:filter(
	 % fun(A) -> 1 end , Nodes),
	    %not lists:member(A,NeighborsInQ) end, Nodes),
  %io:format("RemaningNodes = ~w\n",[RemainingNodes]),
  % Add connected group to the outs and call again with neighbors removed
  %1.
%  rec_get_connected_sub_graphs(
	%lists:filter(
	%  fun(A) ->
	%    not lists:member(A,NeighborsInQ) end, Nodes),
	%NodesDict,
	%[ NeighborsInQ | Outs]).

gather_all_neighbors([],_,OutsDict)-> OutsDict;
  %[ T || {_,T} <-  dict:to_list(OutsDict) ];

gather_all_neighbors(Nodes,NodesDict,OutsDict)->
  1.
%  io:format("gather_all_neighbors\n"),
%  NodeInQ = hd(Nodes),
%  io:format("NodeInQ = ~w\n",[NodeInQ]),
%  Neighbors = 
%   [ NodeInQ |  [ dict:fetch(T,NodesDict) || T <- NodeInQ#node.connections ] ],
%  io:format("Neighbors = ~w\n",[Neighbors]),
%  NewOutsDict =
%    lists:foldl(
%	  fun(A,Acc)->
%	    case dict:is_key(A#node.ident,OutsDict) of
%		  true -> Acc;
%		  false ->
 %           dict:append(A#node.ident,A,Acc) 
	%	end
	%    end,
	 %   OutsDict,Neighbors),
%  io:format("NewOutsDict = ~w\n",[NewOutsDict]),
  
%  gather_all_neighbors(
%    lists:filter(
	%  fun(A)->
	 %   not dict:is_key(A#node.ident,NewOutsDict) end,
	  %Nodes),
    %NodesDict,
    %NewOutsDict).
    