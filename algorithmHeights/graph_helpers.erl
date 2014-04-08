%% @author birketsc
%% @doc @todo Add description to graph_helpers.

-module(graph_helpers).

-include_lib("alg_nodes.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export(
   [
	read_edge_list_file/1,
	get_degree_array/1,
	get_double_degree_array/1]).

read_edge_list_file(File)->
  process_read_edge_list_file(File).

get_double_degree_array(Graph)->
	SortedNodes = 
      lists:sort(
	    fun( #node{ident=AIndex},#node{ident=BIndex}) ->
          AIndex < BIndex end,Graph),
	
	GraphAsDict = graph_as_dict(SortedNodes),
	
	lists:foldl(
	  fun(A,OutAcc) ->
	    OutAcc ++ [
		  lists:foldl(
		    fun(Key,Acc)->
			  Elem = dict:fetch(Key,GraphAsDict),
			  Acc + length(Elem#node.connections)
		    end,0,A#node.connections)
		]
	  end,[],SortedNodes).

get_degree_array(Graph)->
	SortedNodes = 
      lists:sort(
	    fun( #node{ident=AIndex},#node{ident=BIndex}) ->
          AIndex < BIndex end,Graph),
	[ io:format("~w ", [ length( T#node.connections ) ] ) || T <- SortedNodes ].	

%% ====================================================================
%% Internal functions
%% ====================================================================

graph_as_dict(Graph)->
	NodesWithKey = [ { T#node.ident, T } || T <- Graph ],
	dict:from_list(NodesWithKey).

get_degree_array_from_file(File)->
	Graph = read_edge_list_file(File),
	SortedNodes = 
      lists:sort(
	    fun( #node{ident=AIndex},#node{ident=BIndex}) ->
          AIndex < BIndex end,Graph),
	[ io:format("~w ", [ length( T#node.connections ) ] ) || T <- SortedNodes ].

process_read_edge_list_file(File)->
	
  {ok,Data} = file:read_file(File),
  
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  
  Lines = string:tokens(D,"\n"),
  
  [NodeCount,EdgeCount] = 
	  [ element(1,string:to_integer(T)) || T <- string:tokens(hd(Lines)," ")],
  
  % TODO: make distinction for other graph types
  make_undirected_unweighted_graph(NodeCount,EdgeCount,Lines).
  
make_undirected_unweighted_graph(NodeCount,EdgeCount,Lines)->
  Edge_Dict = 
    lists:foldl( 
      fun(A,Acc)->
        [Key,Value] =
          [ element(1,string:to_integer(T)) || T <- string:tokens(A," ") ],
        FirstDict = dict:append(Key, Value, Acc),
		dict:append(Value,Key,FirstDict) end,
	  dict:new(),
	  tl(Lines)),
  
  lists:foldl(
	fun(A,Acc)->
	  case dict:find(A,Edge_Dict) of
	    {ok,Value} ->
          [#node{ident = A,connections = Value} | Acc ];
		_ ->
		  [#node{ident = A,connections = [] } | Acc] end end,
	[],
	lists:seq(1,NodeCount)).