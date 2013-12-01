-module(node_stuff).

-export([regular_node_head/1,regular_node/2,read_until_head/1]).

-include_lib("nodes.hrl").

regular_node(Parent,Val)->
  #node{parent = Parent, value = Val}.

regular_node_head(Val)->
  #node{parent = [], value = Val}.
 
read_until_head(Node)->
  read_until_head_rec(Node,[]).

read_until_head_rec(Node,Vals)->
  if
    Node#node.parent == [] -> Vals ++ [Node#node.value];
    true ->
      read_until_head_rec(Node#node.parent,Vals ++ [Node#node.value])
  end.
