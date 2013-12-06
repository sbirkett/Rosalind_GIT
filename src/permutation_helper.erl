-module(permutation_helper).

-include_lib("nodes.hrl").

-import(node_stuff,[regular_node/2]).
-import(node_stuff,[regular_node_head/1]).
-import(node_stuff,[read_until_head/1]).
-import(node_stuff,[make_leafs/2]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([make_sized_permutations/2]).

make_sized_permutations(Values,Size)->
	
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
			lists:fold( fun (A , Acc) ->
				lists:merge(Acc, node_stuff:make_leafs(Values, A)) end,[],Outs))
end.
