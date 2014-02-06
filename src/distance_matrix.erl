-module(distance_matrix).

-include_lib("../rosalind_records.hrl").
-import(fasta_reader,[read/1]).

-export([solve/1]).

solve(File)->
  compile:file("../fasta_reader.erl"),
  Fastas = [T#fasta.sequence || T <- fasta_reader:read(File) ],
  Rets = make_matrixies(Fastas,Fastas,[]),
  lists:map ( fun ( A ) ->
	lists:map ( fun ( B ) ->
	      io:format("~w ",[B]) end, A),
	io:format("\n") end,Rets).

make_matrixies([],_,Outs)->Outs;
make_matrixies(Vals,AllVals,Outs)->
  make_matrixies(tl(Vals),AllVals,Outs ++ [ make_matrix(hd(Vals),AllVals,[])]).

make_matrix(_,[],Outs)->Outs;
make_matrix(Target,Others,Outs)->
  make_matrix(Target,tl(Others),Outs ++ [ seq_dif(Target,hd(Others))]).

seq_dif(A,B) -> 
  %length(A) / do_dif(A,B,0).
  Ret = do_dif(A,B,0.0),
  case Ret of 
    0 -> 0.0000;
    _ -> Ret / length(A)
  end.

do_dif([],[],Like)->Like;
do_dif(A,B,Like)->
  case ( hd(A) == hd(B) ) of
      true -> do_dif(tl(A),tl(B),Like);
      false -> do_dif(tl(A),tl(B),Like+1)
    end.
