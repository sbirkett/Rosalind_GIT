-module(genome_assembler).

-export([assemble/1,multi_do_right_placement/4]).

-include_lib("../rosalind_records.hrl").
-include_lib("nodes.hrl").

-import(list_helper,[remove_longest_duplication/2]).
-import(fasta_reader,[read/1]).

assemble(N)->
  compile:file("../fasta_reader.erl"),
  compile:file("list_helper.erl"),
  Fastas = fasta_reader:read(N),
  {ok,Logger} =file:open("output.txt",[write]),
  Nodes = construct_nodes(Fastas,[]),
  MakeRet = multi_find_all_best_right_rec(Nodes,1),
  Placed_T = return_listener([],length(Fastas)),
  Placed = lists:sort(fun(A,B) -> A#genomeSection.overlap < B#genomeSection.overlap end,
    Placed_T),
  First = hd(Placed),
  {In,Out} = lists:partition( fun(A) ->
	NextSection = A#genomeSection.right,
	NextSection#genomeSection.sequenceIdent == First#genomeSection.sequenceIdent end, 
  	tl(Placed)),
  Return = 
    build_final_string(
      In,
      Out,
      First#genomeSection.sequence),
  Return.

return_listener(Nodes,Total)->
  receive
    {Node}->
      case (length(Nodes) + 1) == Total of
	true ->
	  [Node|Nodes];
	false ->
	  return_listener([Node|Nodes],Total)
      end
  end.

construct_nodes([],Return)->
  Return;
construct_nodes(Fastas,Return)->
  Fasta = hd(Fastas),
  construct_nodes(tl(Fastas),[
    #genomeSection{
      sequenceIdent = Fasta#fasta.ident,
      sequence = Fasta#fasta.sequence,
      overlap = 0
    }|Return]).

build_final_string(Val,[],Return)->
  ValVal = hd(Val),
  lists:append(
    lists:sublist(
      ValVal#genomeSection.sequence,
      (length(ValVal#genomeSection.sequence) - ValVal#genomeSection.overlap))
      ,Return);
build_final_string(Val,Graph,Return)->
  ValVal = hd(Val),
  ModifiedReturn = 
    lists:append(
      lists:sublist(
	ValVal#genomeSection.sequence,
	(length(ValVal#genomeSection.sequence) - ValVal#genomeSection.overlap))
      ,Return),
  {In,Out} = 
    lists:partition( fun(A) ->
	  NextSection = A#genomeSection.right,
	  NextSection#genomeSection.sequenceIdent == ValVal#genomeSection.sequenceIdent end,
          Graph),
  build_final_string(In,Out,ModifiedReturn).

multi_find_all_best_right_rec(Seqs,Index)->
  case Index == (length(Seqs)+1) of
    false ->
      spawn(
	genome_assembler,
	multi_do_right_placement,
	[lists:nth(Index,Seqs),lists:delete(lists:nth(Index,Seqs),Seqs),lists:nth(Index,Seqs),self()]),
      multi_find_all_best_right_rec(Seqs,Index+1);
    true->
      1
  end.

multi_do_right_placement(Seq,[],Best,Rec_PID)->
  Rec_PID ! {Best};
multi_do_right_placement(Seq,Seqs,Best,Rec_PID)->
  CompareTo = hd(Seqs),
  PossibleNew = 
    list_helper:identify_overlap_with_minimum(
      Seq#genomeSection.sequence,
      CompareTo#genomeSection.sequence,
      0),
  case PossibleNew > Best#genomeSection.overlap of
    true ->
      multi_do_right_placement(
	Seq,
	tl(Seqs),
	#genomeSection{
	  sequenceIdent = Seq#genomeSection.sequenceIdent,
	  sequence = Seq#genomeSection.sequence,
	  overlap = PossibleNew,
	  right = CompareTo},
      Rec_PID);
    false ->
      multi_do_right_placement(
	Seq,
	tl(Seqs),
	Best,
        Rec_PID)
  end.
