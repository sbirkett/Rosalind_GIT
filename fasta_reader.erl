-module(fasta_reader).
-export([read/1,convert_fasta_chunk/1]).


-include_lib("rosalind_records.hrl").

convert_fasta_chunk(Chunk) ->
  
  T = string:tokens(Chunk,">"),
  lists:foldl( fun ( Z, Vals) ->
	X = string:tokens(Z, "\n"),
	Vals ++ [ build_fasta(hd(X),tl(X))] end, [], T).

read(N) ->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  T = string:tokens(D,">"),
  lists:foldl( fun ( Z, Vals) ->
	X = string:tokens(Z,"\n"),
	Vals ++ [ build_fasta(hd(X),tl(X))] end,[],T).

build_fasta(Id,Seq)->
  Z = lists:append( [ L || L <- Seq ] ),
  #fasta{ident = Id, sequence = Z}.
  
