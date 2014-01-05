-module(spliced_motif).

-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).

-export([run/1]).

run(File)->
  compile:file("../fasta_reader.erl"),
  [Second,First] = fasta_reader:read(File),
  Inds = find_indexes(First#fasta.sequence,Second#fasta.sequence,[],1),
  [ io:format("~w ",[T]) || T <- Inds].

find_indexes([],Main,Inds,Pos)->
  Inds;
find_indexes(Sub,Main,Inds,Pos)->
  case hd(Sub) == hd(Main) of
    true ->
      find_indexes(tl(Sub),tl(Main),Inds ++ [Pos],Pos+1);
    false ->
      find_indexes(Sub,tl(Main),Inds,Pos+1)
  end.
