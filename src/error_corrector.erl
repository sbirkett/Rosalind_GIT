-module(error_corrector).

-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).
-import(helpers,[make_reverse_compliment/1]).
-import(helpers,[hamming_distance/2]).

-record(fastaComp,{ident,sequence,revComp}).

-export([correct/1]).

correct(File)->
  compile:file("../fasta_reader.erl"),
  compile:file("../helpers.erl"),

  Fastas = fasta_reader:read(File),

  FastasComp = [ #fastaComp{ident = T#fasta.ident,sequence = T#fasta.sequence,revComp = helpers:make_reverse_compliment(T#fasta.sequence)} || T <- Fastas ],

  {GoodComps,ErrorComps} = find_errors(FastasComp,[],[]),

  lists:foldl( fun ( A , Acc) ->
	Z = lists:filter( fun ( B ) ->
	      (X = helpers:hamming_distance(A#fastaComp.sequence,B#fastaComp.sequence) == 1) or
	      (Y = helpers:hamming_distance(A#fastaComp.sequence,B#fastaComp.revComp) == 1) 
	  end,GoodComps),
        B = hd(Z),
	Reg = helpers:hamming_distance(A#fastaComp.sequence,B#fastaComp.sequence) == 1,
        if
	  Reg ->
	    io:format("~s->~s\n",[A#fastaComp.sequence,B#fastaComp.sequence]);
	  true ->
	    io:format("~s->~s\n",[A#fastaComp.sequence,B#fastaComp.revComp])
	end
   end,[],ErrorComps).

find_errors([],Goods,Bads)->
  {Goods,Bads};
find_errors(Seqs,Goods,Bads)->
  InQ = hd(Seqs),
  Others = tl(Seqs),
  X =
    lists:any(fun(A) ->
	  ( A#fastaComp.sequence == InQ#fastaComp.sequence ) or
	  ( A#fastaComp.sequence == InQ#fastaComp.revComp  ) or 
	  ( A#fastaComp.revComp  == InQ#fastaComp.sequence ) or
	  ( A#fastaComp.revComp  == InQ#fastaComp.revComp  )
          end, Goods),
  Y =
    lists:any(fun(A) ->
	  ( A#fastaComp.sequence == InQ#fastaComp.sequence ) or
	  ( A#fastaComp.sequence == InQ#fastaComp.revComp  ) or 
          ( A#fastaComp.revComp  == InQ#fastaComp.sequence ) or
	  ( A#fastaComp.revComp  == InQ#fastaComp.revComp  )
	  end, Others),
  if
    X or Y ->
      find_errors(Others,[InQ|Goods],Bads);
    true ->
      find_errors(Others,Goods,[InQ|Bads])
  end.
