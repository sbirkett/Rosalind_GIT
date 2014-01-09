-module(shared_spliced_motif).

-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).

-export([start/1]).

start(File)->
  Seqs = [ T#fasta.sequence || T <- fasta_reader:read(File) ] .
 
punch_all_holes(Seq,0,Outs)->
  Outs;
punch_all_holes(Seq,Holes,Outs)->
  1.
