%% @author birketsc
%% @doc @todo Add description to bipartiteness.

-module(bipartiteness).

-import(graph_helpers,[read_multi_edge_list_file/1,graph_as_dict/1]).
-import(permutation_helper,[make_unique_sized_permutations/2]).

-include_lib("alg_nodes.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/1,check_bipartite/1]).

solve(File)->
	
  compile:file("graph_helpers.erl"),
  compile:file("../src/permutation_helper.erl"),
  
  Graphs = graph_helpers:read_multi_edge_list_file(File),
  
  lists:map(
	fun(A) ->
	  io:format("~w ",[check_bipartite(A)]) end,
	Graphs).

check_bipartite(Graph)->
	
  NodePermutations = generate_node_permutations(Graph),
 
  AnyBipartite =
    lists:any(
	  fun({A,B}) ->
	    check_bipartite(A,B) == 1 end,
	  NodePermutations),
  
  case AnyBipartite of
    true -> 1;
	false -> -1
  end.

%% ====================================================================
%% Internal functions
%% ====================================================================

generate_node_permutations(Graph)->
	
  Permutations = 
    permutation_helper:make_unique_sized_permutations(
	  dict:fetch_keys(Graph), 
	  dict:size(Graph)),
  
  lists:foldl(
	fun(A,Acc)->
      lists:map(
		fun(B)->
		  [First,Second] = lists:split(B,A),
		  dict:append_list(First,Second,Acc) end,
		lists:seq(1,length(A)-1)) end,
	[],Permutations).
			
check_bipartite(GraphA,GraphB)->
  1.