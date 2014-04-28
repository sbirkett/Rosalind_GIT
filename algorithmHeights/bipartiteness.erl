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
	
  %% cleanup
  file:delete("graph_helpers.beam"),
  file:delete("node_stuff.beam"),
  file:delete("permutation_helper.beam"),
  
  %% compile other modules
  compile:file("graph_helpers.erl",{outdir,"."}),
  compile:file("../src/node_stuff.erl",{outdir,"."}),
  compile:file("../src/permutation_helper.erl",{outdir,"."}),
  
  Graphs = graph_helpers:read_multi_edge_list_file(File),
  %io:format("SEcondGraph = ~w\n",[tl(Graphs)]).
  check_bipartite(lists:last(Graphs)).
  %io:format("Graphs = ~w\n",[Graphs]),
%  lists:map(
%    fun(A) ->
%      case check_bipartite(A) of
%	true->io:format("1 ");
%	false->io:format("-1 ")
%      end
%    end,
%    Graphs).

check_bipartite(Graph)->
  
  GraphAsDict = graph_helpers:graph_as_dict(Graph),  

  NodePermutations = 
    generate_node_permutations(GraphAsDict),

  check_bipartite_rec(dict:to_list(NodePermutations),GraphAsDict).
  
%% ====================================================================
%% Internal functions
%% ====================================================================

check_bipartite_rec([],_)->false;
check_bipartite_rec([{A,B}|NodePermutations],GraphDict)->
  case check_bipartite_sections(A,hd(B),GraphDict) of
    true -> true;
    false -> check_bipartite_rec(NodePermutations,GraphDict)
  end.

generate_node_permutations(Graph)->

  Permutations = 
    permutation_helper:make_unique_sized_permutations(
	  lists:seq(1,dict:size(Graph)),
	  dict:size(Graph)),

  KeyValueTuples = 
    lists:foldl(
      fun(A,Acc) ->
        lists:merge(Acc,A)
      end,
      [],
      [ dict:to_list(make_key_value_dicts(T)) || T <- Permutations ]),

  lists:foldl(
    fun({AKey,AValue},Acc) ->
      dict:store(AKey,AValue,Acc)
    end,
    dict:new(),
    KeyValueTuples).

make_key_value_dicts(Permutation)->
  lists:foldl(
    fun(A,Acc)->
      {ListA,ListB} = lists:split(A,Permutation),
      SortedA = lists:sort(ListA),
      dict:append(SortedA,ListB,Acc)
    end,
    dict:new(),
    lists:seq(1,length(Permutation)-1)).

check_bipartite_sections(AGraphKeys,BGraphKeys,GraphDict)->

  %io:format("check_bipartite_sections\n"),
  %io:format("AGraphKeys = ~w\n",[AGraphKeys]),
  %io:format("BGraphKeys = ~w\n",[BGraphKeys]),

  AGraph =
    dict:filter(
      fun(Key,_) ->
        lists:member(Key,AGraphKeys) end,
      GraphDict),

  BGraph =
    dict:filter(
      fun(Key,_) ->
	lists:member(Key,BGraphKeys) end,
      GraphDict),
    %io:format("Checking A Section\n"),
 
    %io:format("AGraph = ~w\n",[dict:to_list(AGraph)]),
    %io:format("BGraph = ~w\n",[dict:to_list(BGraph)]),
  
  ASection = 
    check_unique_section(
      [ element(2,T) || T <- dict:to_list(AGraph) ],
      AGraph),
    %io:format("Checking B Section\n"),
  BSection = 
    check_unique_section(
      [ element(2,T) || T <- dict:to_list(BGraph) ],
      BGraph),
  
  ASection and BSection.
       
check_unique_section([],_)-> true;
check_unique_section(Graph,GraphDict)->
  NodeInQ = hd(Graph),
  %io:format("NodeInQ = ~w\n",[NodeInQ]),
  %io:format("GraphDict = ~w\n",[dict:to_list(GraphDict)]),
  case lists:any(
      fun(A)->
        dict:is_key(A,GraphDict) end,
      NodeInQ#node.connections) of
    false ->
      %io:format("Was false\n"), 
      check_unique_section(tl(Graph),GraphDict);
    true -> 
      %io:format("Was TRUE\n"),
      false
  end.
