-module(perfect_matching).

-export([solve/1]).

-include_lib("../rosalind_records.hrl").
-import(fasta_reader,[read/1]).

solve(File)->
  compile:file("../fasta_reader.erl"),
  Fasta = hd(fasta_reader:read(File)),
  Seq = Fasta#fasta.sequence,
  AUCount = length( [ T || T <- Seq , (T == hd("A"))or( T ==hd("U")) ]),
  CGCount = length(Seq) - AUCount,

  factorial(round(AUCount/2)) * factorial(round(CGCount/2)).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).
