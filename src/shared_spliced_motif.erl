-module(shared_spliced_motif).

-include_lib("../rosalind_records.hrl").

-record(problemSet,{seq,first,second}).

-import(fasta_reader,[read/1]).

-export([start/1]).

start(File)->
  Seqs = [ T#fasta.sequence || T <- fasta_reader:read(File) ],
  FirstProblem = #problemSet{seq=[],first=hd(Seqs),second=lists:last(Seqs)},
  iterate([FirstProblem],[]).

iterate([],Answers)->
  Answers;
iterate(ProblemSets,Answers)->
  {Problem,Answer} = advance_problem(hd(ProblemSets)),
  case Answer == [] of
    true ->
      iterate(lists:merge(tl(ProblemSets),Problem),Answers);
    false ->
      iterate(tl(ProblemSets),Answers ++ [Answer])
  end.

advance_problem(ProblemSet)->
  {1,[]}.

% Advance frame until matching chars found
% Determine number of matching chars
% Make new problem(s) from the advanced frame

is_complete(ProblemSet)->
  1.
