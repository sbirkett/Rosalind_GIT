-module(rna_splicing).
-export([start/1]).

-include_lib("rosalind_records.hrl").
-import(fasta_reader,[read/1]).
-import(helpers,[translate_dna_rna/1]).
-import(helpers,[translate_rna_prot/1]).

start(N)->
  compile:file(fasta_reader),
  Fastas = [ K#fasta.sequence || K <- fasta_reader:read(N)],
  Cleaned = clean_introns(hd(Fastas),tl(Fastas)),
  %io:format("~s\n",[helpers:translate_rna_prot(helpers:translate_dna_rna(Cleaned))]).
  io:format("~s\n\n",[hd(Fastas)]),
  io:format("~s\n\n",[Cleaned]),
  io:format("~s\n\n",[helpers:translate_dna_rna(Cleaned)]),
  io:format("~s\n\n",[helpers:translate_rna_prot(helpers:translate_dna_rna(Cleaned))]).

clean_introns(N,X)->
  if
    X == [] -> N;
    true -> clean_introns(re:replace(N,hd(X),"",[global,{return,list}]),tl(X))
  end.

