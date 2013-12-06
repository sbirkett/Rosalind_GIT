-module(overlap_graph).
-export([start/1]).

-record(node,{ident,start,finish}).

start(N) ->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,">"),
  Tt = lists:foldl( fun(Z,Vals) -> 
	X = string:tokens(Z,"\n"),
	Vals ++ [build_node(hd(X),tl(X))] end,[],T),%lists:nth(2,X))] end, [],T),
  %io:format("~w\n",[Tt]),
  TheEdges = find_edges(Tt,[]),
  lists:foldl( fun(Z,Vals) ->
	eval(Z) end, [],TheEdges).  
	
eval(Z)->
  if
    Z == [] -> [];
    1 == 1 -> evaluate(Z)
  end.

evaluate(Z)->
    First = lists:nth(1,Z),
    Second = lists:nth(2,Z),
    if
      Second == [] -> [];
      1 == 1 -> io:format("~s ~s\n",[First#node.ident,Second#node.ident])
    end.
    
find_edges(In,Out)->
  if
    length(In) == 0 -> Out;
    1 == 1 -> find_edges(tl(In),Out ++ find_matches(hd(In),tl(In),[]))
  end.

find_matches(Input,Others,Ret)->
  if
    Others == [] -> Ret;
    1 == 1 -> find_matches(Input,tl(Others),Ret ++ [make_matches(Input,hd(Others))])
  end.

make_matches(Input,Other)->
  Aa = Input#node.start,
  Ab = Input#node.finish,
  Ba = Other#node.start,
  Bb = Other#node.finish,
  if
    Aa == Bb -> [Other,Input];
    Ab == Ba -> [Input,Other];
    1 == 1 -> 
      io:format("Input = ~s Other = ~s NOT EQUAL\n",[Input#node.ident,Other#node.ident]),
      io:format("IStart = ~s IFinish = ~s \n",[Input#node.start,Input#node.finish]),
      io:format("OFinish = ~s OStart = ~s \n",[Other#node.finish,Other#node.start]),
      []
  end.
    

build_node(X,Y)->
  %io:format("X = ~w\n",[X]),
  %io:format("Y = ~w\n",[Y]),
  %io:format("First = ~s\n",[lists:sublist(Y,3)]),
  %io:format("Last = ~s\n",[lists:sublist(Y,length(Y)-2,length(Y))]),
  Z = lists:append( [ L || L <- Y ] ),
  %io:format("Z = ~s\n",[Z]),
  #node{ident = X, start = lists:sublist(Z,3), finish = lists:sublist(Z,length(Z)-2,length(Z))}.
