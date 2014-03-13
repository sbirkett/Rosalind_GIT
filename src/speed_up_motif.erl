%% @author birketsc
%% @doc @todo Add description to speed_up_motif.
-module(speed_up_motif).

-include_lib("../rosalind_records.hrl").
-import(fasta_reader,[read/1]).


%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/1,build_failure_array/1]).

solve(File)->
  compile:file("../fasta_reader.erl"),
  Fasta = hd(fasta_reader:read(File)), 
  Seq = Fasta#fasta.sequence,
  build_failure_array(Seq).
  


build_failure_array(Seq)->
  search_failure_array(2,Seq,[0]).

%% ====================================================================
%% Internal functions
%% ====================================================================

search_failure_array(Index,Seq,Outs)->
  case (Index == (length(Seq)+1)) of
    true -> Outs;
	false -> 
	  SubList = lists:sublist(Seq,Index),
	  {Head,Tail} = lists:split( length(SubList) div 2 , SubList ),
      search_failure_array( 
		Index+1,
		Seq, 
		Outs ++ [ get_longest_substring(Head,Tail) ] )
  end.


get_longest_substring([],_)-> 0;
get_longest_substring(Head,Tail)->
	
  % Find all indexes in Head[x] == Last(Tail)
  Indexes = get_all_indexes_of(lists:last(Tail),1,Head,[]),
  
  check_all_indexes(Indexes,Head,Tail).


check_all_indexes([],_,_)->0;
check_all_indexes(Indexes,Head,Tail)->
  SubHead = lists:sublist(Head, hd(Indexes)),
  SubTail = lists:nthtail(length(Tail) - length(SubHead) , Tail),
  %io:format("SubHead = ~w\n",[SubHead]),
  %io:format("SubTail = ~w\n",[SubTail]),
  case SubHead == SubTail of
	  true-> hd(Indexes);
	  false-> check_all_indexes(tl(Indexes),Head,Tail)
  end.

get_all_indexes_of(_,_,[],Outs)->Outs;
get_all_indexes_of(Char,Index,List,Outs)->
  case Char == hd(List) of
    true -> get_all_indexes_of(Char,Index+1,tl(List),[Index | Outs]);
	false -> get_all_indexes_of(Char,Index+1,tl(List),Outs)
  end.
