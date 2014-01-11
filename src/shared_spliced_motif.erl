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
  FilteredProblems = filter_problems(ProblemSets),
  {Problem,Answer} = advance_problem(hd(FilteredProblems)),
  case Answer == [] of
    true ->
      iterate(lists:merge(tl(FilteredProblems),Problem),Answers);
    false ->
      iterate(tl(FilteredProblems),Answers ++ [Answer])
  end.

advance_problem(ProblemSet)->
  IsComplete = is_complete(ProblemSet),
  case IsComplete of 
    true ->
      {[],ProblemSet#problemSet.seq};
    false ->
      % Do stuff
      {1,[]}
  end.

% Advance frame until matching chars found
% Determine number of matching chars
% Make new problem(s) from the advanced frame

is_complete(ProblemSet)->
  MatchingChars =
    list:filter( fun(A) ->
	  list:member(A,ProblemSet#problemSet.second) end,ProblemSet#problemSet.first),
  length(MatchingChars) == 0.

filter_problems(ProblemSets)->
  Longest = hd(lists:sort(fun(A,B) -> 
	  length(A#problemSet.seq) > length(B#problemSet.seq) end, ProblemSets)),
  lists:filter( fun(A) ->
	(length(A#problemSet.first) > Longest) and
	(length(A#problemSet.second) > Longest) end, ProblemSets).

