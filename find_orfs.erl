-module(find_orfs).
-export([start/1]).

-include_lib("rosalind_records.hrl").

-import(fasta_reader,[read/1]).
-import(helpers,[translate_dna_rna/1]).
-import(helpers,[translate_rna_prot/1]).
-import(helpers,[make_reverse_compliment/1]).
-import(helpers,[find_all_pos/4]).

start(N)->
  Fastas = [ K#fasta.sequence || K <- fasta_reader:read(N)],
  WindowA = helpers:translate_rna_prot(helpers:translate_dna_rna(hd(Fastas))),
  WindowB = helpers:translate_rna_prot(helpers:translate_dna_rna(lists:nthtail(1,hd(Fastas)))),
  WindowC = helpers:translate_rna_prot(helpers:translate_dna_rna(lists:nthtail(2,hd(Fastas)))),
  WindowD = helpers:translate_rna_prot(helpers:translate_dna_rna(
      		helpers:make_reverse_compliment(hd(Fastas)))),
  WindowE = helpers:translate_rna_prot(lists:nthtail(1,helpers:translate_dna_rna(
	helpers:make_reverse_compliment(hd(Fastas))))),
  WindowF = helpers:translate_rna_prot(lists:nthtail(2,helpers:translate_dna_rna(
	helpers:make_reverse_compliment(hd(Fastas))))),
  I = find_all_windows([WindowA,WindowB,WindowC,WindowD,WindowE,WindowF],[]),
  [ io:format("~s\n",[X]) || X <- I].

find_all_windows(Input,Out)->
  if
    Input == [] -> Out;
    true ->
      AS = re:replace(hd(Input),"Stop","#",[global,{return,list}]),
      WindowS = helpers:find_all_pos(AS,"#",0,[]),
      WindowM = helpers:find_all_pos(AS,"M",0,[]),
      find_all_windows(tl(Input),
	lists:usort(
	  lists:merge(Out,
	    find_windows(AS,WindowM,WindowS,[]))))
    end.

find_windows(Input,Ms,Stops,Out)->
  Combs = lists:foldl( fun(A,Acc) ->
	  Acc ++ [ [A,B] || B <- Stops ] 
      end,
      [],
      Ms),
    
  lists:foldl( fun(A,Acc) ->
	Mpos = hd(A),
	Spos = hd(tl(A)),
	if
	  Mpos < Spos ->
	    Subpos = string:sub_string(Input,Mpos+1,Spos),
	    IsMem = lists:member(hd("#"),Subpos),
	    if
	      IsMem -> Acc;
	      true ->
		[Subpos|Acc]
	    end;
	  true->
	    Acc
	end
    end,[],Combs).
