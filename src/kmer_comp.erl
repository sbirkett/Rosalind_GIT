-module(kmer_comp).

-export([get_comp/1]).

-include_lib("nodes.hrl").
-include_lib("../rosalind_records.hrl").

-import(node_stuff,[regular_node/2]).
-import(node_stuff,[regular_node_head/1]).
-import(node_stuff,[read_until_head/1]).
-import(fasta_reader,[read/1]).

get_comp(File)->
  compile:file("node_stuff.erl"),

  compile:file("../fasta_reader.erl"),

  Fasta = hd(fasta_reader:read(File)),

  Perms = lists:sort(fun(A,B) -> string:to_lower(A) < string:to_lower(B) end,make_permutations([65,67,71,84],4)),

  Matching_Dict = 
    lists:foldl( fun( A, Acc) ->
	  dict:store(A,0,Acc) end, dict:new(),Perms),

  Matched = run_matches(Matching_Dict,Fasta#fasta.sequence),

  lists:foldl( fun (A , Acc ) ->
	io:format("~w ",[dict:fetch(A,Matched)]) end,[],Perms).

run_matches(Matching_Dict,Seq)->
  case length(Seq) >= 4 of
    true ->
      SubSeq = lists:sublist(Seq,4),
      run_matches(
	dict:update(SubSeq, fun(Old) -> 
	      Old + 1 end, Matching_Dict),tl(Seq));
    false->
      Matching_Dict
  end.

make_permutations(Chars,Depth)->
  Parents = lists:foldl( fun ( A, Acc)->
	Acc ++ [node_stuff:regular_node_head(A)] end, [], Chars),

  Leafs = make_permutations_rec(Chars,Depth,1,Parents),

  Vals = lists:foldl( fun ( A, Acc) ->
	[ node_stuff:read_until_head(A)|Acc] end,[],Leafs),

  Vals.

make_permutations_rec(Chars,Depth,Count,Outs)->
  if
    Depth == Count -> Outs;
    true ->
      make_permutations_rec(Chars,Depth,Count+1,
	lists:foldl( fun ( A, Acc) ->
	      lists:merge(Acc,make_leafs(Chars,A)) end , [], Outs))
  end.

make_leafs(Chars,Parent)->
  lists:foldl( fun ( A , Acc) ->
	Acc ++ [ node_stuff:regular_node(Parent,A)] end,[],Chars).
