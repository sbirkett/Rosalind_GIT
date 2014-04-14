-module(permutation_helper).

-include_lib("/Users/scott/Documents/workspace/Rosalind_GIT/src/nodes.hrl").

-import(node_stuff,[regular_node/2]).
-import(node_stuff,[regular_node_head/1]).
-import(node_stuff,[read_until_head/1]).
-import(node_stuff,[make_leafs/2]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([make_sized_permutations/2,make_unique_sized_permutations/2]).

make_unique_sized_permutations(Values,Size)->
  io:format("make_u\n"),
  %compile:file("/Users/scott/Documetns/workspace/Rosalind_GIT/src/node_stuff.erl"),
 1. 
%  	Parents = lists:foldl( fun ( A , Acc ) ->
% 		Acc ++ [node_stuff:regular_node_head(A)]  end, [], Values),
 	
% 	Leafs = make_sized_permutations_rec(Values,Size,1,Parents),
	
% 	lists:foldl( fun(A,Acc) -> 
%		PotentialPermutation = node_stuff:read_until_head(A),
%		case 
%			length(PotentialPermutation) == 
%		    sets:size(sets:from_list(PotentialPermutation)) of
%			true ->
% 				[ node_stuff:read_until_head(A) | Acc ] ;
%			false -> Acc
%		end
%		end, [], Leafs).

make_sized_permutations(Values,Size)->
	
	%compile:file("node_stuff.erl"),
	
	Parents = lists:foldl( fun ( A , Acc ) ->
 		Acc ++ [node_stuff:regular_node_head(A)]  end, [], Values),
 	
 	Leafs = make_sized_permutations_rec(Values,Size,1,Parents),
	
 	lists:foldl( fun(A,Acc) -> 
 		[ node_stuff:read_until_head(A) | Acc] end, [], Leafs).

%% ====================================================================
%% Internal functions
%% ====================================================================

make_sized_permutations_rec(Values,Size,CurrentDepth,Outs)->
	
	if
		Size == CurrentDepth -> Outs;
		true -> 
			make_sized_permutations_rec(Values,Size,CurrentDepth+1,
				lists:foldl( fun (A , Acc) ->
					lists:merge(Acc, node_stuff:make_leafs(Values, A)) end,[],Outs))
end.
