-module(motif).
-export([start/1]).

start(N)->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,"\n"),
  K = find_motifs(lists:nth(1,T),lists:nth(2,T),[],1),
  {Who,Z} = lists:partition(fun(A) -> A == 0 end, K),
  io:format("~w\n",[Z]).

find_motifs(A,B,X,Count)->
  T = iolist_size(A),
  Z = iolist_size(B),
  if
    A == [] -> X;
    T < Z -> X;
    1 == 1 -> find_motifs(lists:nthtail(1,A),B,X ++ [motif(lists:sublist(A,Z),B,Count)],Count+1)
  end.
  
motif(A,B,Count)->
  if
    A == B -> Count;
    1 ==1 -> 0
  end.
