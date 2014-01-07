-module(complete_tree).

-include_lib("nodes.hrl").

-export([start/1]).

start(File)->
  {ok,Data} = file:read_file(File),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,"\n"),
  {GraphCount,Others} = string:to_integer(hd(T)),

  Nodes = [ #graphNode{ident=T,adjacents=[]} || T <- lists:seq(1,GraphCount) ],

  ConnectedNodes = make_connections(Nodes,tl(T)),
  io:format("~w\n",[ConnectedNodes]).

clump_crawler(Previous,Current,[])->
  length(Previous) -1;
clump_crawler(Previous,Current,Rem)->
  1.

make_connections(Nodes,[])->
  Nodes;
make_connections(Nodes,List)->
  Toks = string:tokens(hd(List)," "),
  {From,Oth} = string:to_integer(re:replace(hd(Toks), "(^\\s+)|(\\s+$)", "", [global,{return,list}])),
  {To,O} = string:to_integer(re:replace(lists:last(Toks), "(^\\s+)|(\\s+$)", "", [global,{return,list}])),
  FromNode = hd(lists:filter( fun(A) -> 
	  A#graphNode.ident == From end, Nodes)),
  ToNode = hd(lists:filter( fun(A) ->
	  A#graphNode.ident == To end, Nodes)),
  NewFromNode = #graphNode{
    ident=FromNode#graphNode.ident,
    adjacents=[To|FromNode#graphNode.adjacents]},
  NewToNode = #graphNode{
    ident=ToNode#graphNode.ident,
    adjacents=[From|ToNode#graphNode.adjacents]},
  LessFromNode = [NewFromNode|lists:delete(FromNode,Nodes)],
  make_connections([NewToNode|lists:delete(ToNode,LessFromNode)],tl(List)).

