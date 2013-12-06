-module(restriction_sites).
-export([start/1]).

-compile(helpers).
-import(helpers,[make_permutations/1]).
-import(fasta_reader,[read/1]).

-include_lib("rosalind_records.hrl").

start(N)->
  compile:file("helpers.erl"),
  compile:file("fasta_reader.erl"),
  Fastas = [ K#fasta.sequence || K <- fasta_reader:read(N)],
  Comps = [ [ A, make_compliment(lists:reverse(A)) ] || A <- helpers:make_permutations(hd(Fastas)),  
  length(A) rem 2 == 0],
  lists:foldl( fun(I,Acc) -> 
	Ret = string:equal(hd(I),hd(tl(I))),
        if
	  Ret -> 
            Locations = get_substring_indexes(hd(Fastas),hd(I),[]),
	    lists:foldl( fun(E,R) -> 
		  io:format("~w ~w\n",[E,length(hd(I))]) end,[],Locations);
	  true -> Z = 2
	end
    end,[],Comps).

get_substring_indexes(N,X,Y)->
  if
    N == [] -> Y;
    true ->
      Position = string:rstr(N,X),
      if
	Position == 0 -> Y;
	true -> get_substring_indexes(string:substr(N,1,Position),X,Y++[Position])
      end
  end.
      
make_compliment(N)->
  K = re:replace(N,"T","Z",[global,{return,list}]),
  J = re:replace(K,"C","Y",[global,{return,list}]),
  B = re:replace(J,"G","C",[global,{return,list}]),
  C = re:replace(B,"A","T",[global,{return,list}]),
  T = re:replace(C,"Z","A",[global,{return,list}]),
  re:replace(T,"Y","G",[global,{return,list}]).
