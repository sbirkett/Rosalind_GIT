-module(longest_motif).
-export([start/1]).
-import(fasta_reader,[read/1]).
-compile(fasta_reader).

-include_lib("rosalind_records.hrl").

start(N) ->
  Fastas = [ K#fasta.sequence || K <- fasta_reader:read(N)],
  SecondSeq = hd(tl(Fastas)),
  First = lists:usort(fun(I,J) -> length(I) > length(J) end,generate_permutations(hd(Fastas),[],SecondSeq)),
 % Second = lists:usort( fun(I,J) -> length(I) < length(J) end, generate_permutations(hd(tl(Fastas)),[])),
  run_until_found(First,tl(Fastas)).
  %1.
  %generate_and_mash(tl(Fastas),First).
  %lists:last(generate_and_mash(Fastas,First)).
  %Z = [ lists:usort(generate_permutations(X#fasta.sequence,[])) || X <- Fastas] ,
  %Z.%lists:last(lists:sort(merge_lists(tl(Z),hd(Z)))).

is_in_all_seqs(N,Seqs)->

  %io:format("N = ~w\n",[N]),
  %io:format("Seq = ~w\n",[hd(Seqs)]),
  %Isin = string:str(hd(Seqs),N),
  %io:format("Isin = ~w\n",[Isin]),
  if
    Seqs == [] -> true;
    %Isin < 1 -> false;
    true ->
     Isin = string:str(hd(Seqs),N), 
      if
	Isin < 1 -> false;
	true -> is_in_all_seqs(N,tl(Seqs))
      end
      %is_in_all_seqs(N,tl(Seqs))
  end.
  
run_until_found(N,Y)->
  %io:format("N = ~w\n",[N]),
  %io:format("Y = ~w\n",[Y]),
  Isinall = is_in_all_seqs(hd(N),Y),
  %io:format("Isinall = ~w\n",[Isinall]),
  if
    N == [] -> "Nothing";
    Isinall -> hd(N);
    true-> run_until_found(tl(N),Y)
  end.
  
%merge_lists(Z,X)->
 % if
  %  Z == [] -> X;
   % true -> merge_lists(tl(Z), [ A || A <- hd(Z), lists:member(A,X) ])
  %end.

%generate_and_mash(N,X)->
 %% if
  %  N == [] -> X;
   % true ->
    %  generate_and_mash(tl(N),
%	[ Z || Z <- generate_permutations(hd(N),[]), lists:member(Z,X)])
 % end.

generate_permutations(N,X,Y) ->
  %%io:format("N = ~w\n",[N]),
  %io:format("X = ~w\n",[X]),
  %io:format("lengthX = ~w\n",[length(X)]),
  %io:format("Y = ~w\n",[Y]),
  if
    N == [] -> X;%lists:usort(fun(I,J) -> length(I) < length(J) end,X);
    %X == [] -> generate_permutations(tl(N), gen_perms(N,[]));
    true -> 
      	%io:format("gen_perms_ret = ~w\n",[gen_perms(N,[])]),
	%io:format("gen_perms in Y = ~w\n",[[A || A <- gen_perms(N,[]),string:str(Y,A) > 0 ]]),
	     generate_permutations(tl(N),
	       lists:umerge(X,[ A || A <-  gen_perms(N,[]), string:str(Y,A)>0]),Y)
  end.

gen_perms(Y,X)->
  if
    Y == [] -> lists:usort(fun(I,J)-> length(I) < length(J) end,X);
    true -> gen_perms(lists:sublist(Y,length(Y)-1), 
	X++[Y])
  end.
