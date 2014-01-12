-module(shared_spliced_motif).

-include_lib("../rosalind_records.hrl").

-record(problemSet,{seq,first,second}).

-import(fasta_reader,[read/1]).
-import(helpers,[index_of/2]).

-export([start/1]).

%==================== Exposed ==============================

start(File)->

  % Compile other modules
  compile:file("../helpers.erl"),
  compile:file("../fasta_reader.erl"),

  % Read input file
  Seqs = [ T#fasta.sequence || T <- fasta_reader:read(File) ],

  % Build problemSet
  FirstProblem = #problemSet{seq=[],first=hd(Seqs),second=lists:last(Seqs)},

  % Profit
  hd(lists:sort( fun(A,B) ->
	  length(A) > length(B) end ,iterate([FirstProblem],[]))).

%===================== Internal ============================

get_minimal_frame_and_intersection(A,B,FrameSize)->
  SubA = lists:sublist(A,FrameSize),
  SubB = lists:sublist(B,FrameSize),
  AIntB = sets:to_list(sets:intersection(sets:from_list(SubA),sets:from_list(SubB))),
  case ( length(AIntB) == 0 ) of
    true ->
      get_minimal_frame_and_intersection(A,B,FrameSize +1);
    false ->
      {FrameSize,AIntB}
  end.

decide_better_problemset(A,B)->
  {AFrameSize,AInt} = get_minimal_frame_and_intersection(A#problemSet.first,A#problemSet.second,1),
  {BFrameSize,BInt} = get_minimal_frame_and_intersection(B#problemSet.first,B#problemSet.second,1),
  case (AFrameSize < BFrameSize) of
    true ->
      A;
    false ->
      B
  end.

iterate([],Answers)->
  Answers;
iterate(ProblemSets,Answers)->
  %io:format("iterate\n",[]),
  %io:format("ProblemSets = ~w\n",[ProblemSets]),
  %io:format("Answers = ~w\n",[Answers]),
  %FilteredProblems = filter_problems(ProblemSets),
  %io:format("FilteredProblems = ~w\n",[FilteredProblems]),
  %{Problem,Answer} = advance_problem(hd(FilteredProblems)),
  {Problem,Answer} = advance_problem(hd(ProblemSets)),
  case Answer == [] of
    true ->
      case ( (length(Problem) > 1) == true) of
	true ->
	  Better_Problem = decide_better_problemset(hd(Problem),lists:last(Problem)),
	  %iterate(tl(FilteredProblems) ++ [Better_Problem],Answers);
	  iterate([Better_Problem],Answers);
	false ->
	  iterate(Problem,Answers)
	  %iterate(tl(FilteredProblems) ++ Problem,Answers)
      end;
    false ->
      Answers ++ [Answer]
      %iterate(tl(FilteredProblems),Answers ++ [Answer])
  end.

advance_problem(ProblemSet)->
  %io:format("advance_problem\n",[]),
  IsComplete = is_complete(ProblemSet),
  %io:format("IsComplete = ~w\n",[IsComplete]),
  case IsComplete of 
    true ->
      {[],ProblemSet#problemSet.seq};
    false ->
      {MinimalFrame,InterSec} =
         get_minimal_frame_and_intersection(ProblemSet#problemSet.first,ProblemSet#problemSet.second,1),
      % DO advancement
      NewProblems = 
        lists:foldl( fun(A,Acc) ->
	  [do_advancement(ProblemSet,A)|Acc] end,[],InterSec),    
     {NewProblems,[]}
  end.

do_advancement(ProblemSet,Char)->
  AInd = helpers:index_of(Char,ProblemSet#problemSet.first),
  BInd = helpers:index_of(Char,ProblemSet#problemSet.second),
  NewProblem =
    #problemSet{
      seq = ProblemSet#problemSet.seq ++ [Char],
      first = lists:nthtail(AInd,ProblemSet#problemSet.first),
      second = lists:nthtail(BInd,ProblemSet#problemSet.second)},
  NewProblem.

is_complete(ProblemSet)->
  MatchingChars =
    lists:filter( fun(A) ->
	  lists:member(A,ProblemSet#problemSet.second) end,ProblemSet#problemSet.first),
  length(MatchingChars) == 0.

filter_problems(ProblemSets)->
  case (length(ProblemSets) == 1) of 
      true ->
	ProblemSets;
      false ->
        Longest = hd(lists:sort(fun(A,B) -> 
	  length(A#problemSet.seq) > length(B#problemSet.seq) end, ProblemSets)),
        Filtered = lists:filter( fun(A) ->
	      ( ( length(A#problemSet.seq) + length(A#problemSet.first) ) > length(Longest#problemSet.seq)) and
	      ( (length(A#problemSet.seq) + length(A#problemSet.second) ) > length(Longest#problemSet.seq)) end, lists:delete(Longest,ProblemSets)),
        Filtered ++ [Longest]
  end.
