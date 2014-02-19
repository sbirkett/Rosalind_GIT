-module(catalan_numbers.erl).

-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).

export([solve/1]).

solve(File)->
  compile:file("../fasta_reader.erl"),
  Fasta = hd(fasta_reader:read(File)),
  Seq = Fasta#fasta.sequence.
