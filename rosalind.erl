-module(rosalind).
-export([start/1]).

problem_1(N,Input) ->
  io:format("~w",[Input]),
   if
     N == [] -> Input;
     hd(N) == 65 -> problem_1( tl(N) , [lists:nth(1,Input)+1] ++ lists:nthtail(1,Input));
     hd(N) == 67 -> problem_1( tl(N) , [lists:nth(1,Input)] ++ [lists:nth(2,Input)+1] ++ lists:nthtail(2,Input));
     hd(N) == 71 -> problem_1( tl(N) , lists:sublist(Input,2) ++ [lists:nth(3,Input)+1] ++ lists:nthtail(3,Input));
     hd(N) == 84 -> problem_1( tl(N) , lists:sublist(Input,3) ++ [lists:nth(4,Input)+1]);
     1 == 1 -> problem_1(tl(N),Input)
   end.

problem_2(N,O) ->
  re:replace(N,"T","U",[global,{return,list}]).
  
problem_3(N) ->
  K = re:replace(N,"T","Z",[global,{return,list}]),
  J = re:replace(K,"C","Y",[global,{return,list}]),
  B = re:replace(J,"G","C",[global,{return,list}]),
  C = re:replace(B,"A","T",[global,{return,list}]),
  T = re:replace(C,"Z","A",[global,{return,list}]),
  E = re:replace(T,"Y","G",[global,{return,list}]),
  lists:reverse(E).
	
problem_GC_Content(N)->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,">"),
  K = gc_Content_Helper(T,0,0),
  K.
  %calc_GC(hd(T)).

gc_Content_Helper(N,X,Y)->
  if
    N == [] -> [X,Y];
    1 == 1 -> gc_Content_Helper2(N,X,Y)
  end.

gc_Content_Helper2(N,X,Y)->
  Z = calc_GC(hd(N)),
  P = lists:nth(2,Z),
  if
    P > Y -> gc_Content_Helper(tl(N),lists:nth(1,Z),lists:nth(2,Z));
    1 == 1 -> gc_Content_Helper(tl(N),X,Y)
  end.

calc_GC(N)->
  T = string:tokens(N,"\n"),
  [hd(T),base_GC_Calc(lists:concat(tl(T)),0,0)].
  
base_GC_Calc(N,X,Y)->
  if
    N == [] -> X / Y * 100;
    hd(N) == 67 -> base_GC_Calc(tl(N),X+1,Y+1);
    hd(N) == 71 -> base_GC_Calc(tl(N),X+1,Y+1);
    1 == 1 -> base_GC_Calc(tl(N),X,Y+1)
  end.

problem_Haming(N)->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,"\n"),
  haming_help(hd(T),lists:nth(2,T),0).

haming_help(N,Y,Z)->
  if
    N == [] -> Z;
    1 == 1 -> haming_help2(N,Y,Z) 
  end.

haming_help2(N,Y,Z)->
  T = hd(N),
  K = hd(Y),
  if
    T == K -> haming_help(tl(N),tl(Y),Z);
    1 == 1 -> haming_help(tl(N),tl(Y),Z+1)
  end. 
	
start(N) ->
 % %problem_1(N,[0,0,0,0]).
  %problem_3(N).
  %problem_GC_Content(N).
  problem_Haming(N).
