-module(complete_tree).

-export([start/1]).

start(File)->
  {ok,Data} = file:read_file(File),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,"\n"),
  {GraphCount,Others} = string:to_integer(hd(T)),

  Edges = get_edges(tl(T),[]),

  UEdges = lists:usort([ lists:sort(Y) || Y <- Edges ] ),

  GraphCount - 1 - length(Edges).

get_edges([],Outs)->
  Outs;
get_edges(Lines,Outs)->
  Toks = string:tokens(hd(Lines)," "),
  {From,Oth} = string:to_integer(re:replace(hd(Toks), "(^\\s+)|(\\s+$)", "", [global,{return,list}])),
  {To,O} = string:to_integer(re:replace(lists:last(Toks), "(^\\s+)|(\\s+$)", "", [global,{return,list}])),
  get_edges(tl(Lines),[[From,To]|Outs]).
