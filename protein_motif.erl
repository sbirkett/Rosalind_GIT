-module(protein_motif).

-include_lib("rosalind_records.hrl").

-export([find_motif/1]).
-import(fasta_reader,[convert_fasta_chunk/1]).	
-import(helpers,[fetch_uniprot/1]).

%N-glycosylation motif is written as N{P}[ST]{P}.

find_motif(InFile)->
  {ok,Data} = file:read_file(InFile),
  FileContent = re:replace(Data,"$<<","",[global,{return,list}]),
  UniProtIDs = string:tokens(FileContent,"\n"),
  Fastas =
  	lists:foldl( fun( ID , Acc ) ->
	      Fas = fasta_reader:convert_fasta_chunk(
		helpers:fetch_uniprot(ID)),
	      Acc ++ [[ID|Fas]] end, [], UniProtIDs),
	
	lists:foldl( fun ( Seq, Acc ) ->
	      Fasta = lists:nth(2,Seq),
	      io:format("\n~s\n",[hd(Seq)]),
	      [ io:format("~w ",[element(1,hd(Loc))+1]) || Loc <- find_motifs(Fasta#fasta.sequence)]
	    end,[], Fastas).
		
find_motifs(Sequence)->
  case re:run(Sequence,"(?=N[^P][S|T][^P])",[global]) of
    {match,Matches} -> Matches;
    nomatch -> [] ;
    {error,no_scheme} -> []
  end.
