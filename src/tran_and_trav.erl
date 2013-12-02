-module(tran_and_trav).

-export([start/1]).

-compile("../fasta_reader.erl").
-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).

start(N)->
  Fastas = fasta_reader:read(N),
  FirstFasta = hd(Fastas),
  FirstSeq = FirstFasta#fasta.sequence,
  SecondFasta = lists:last(Fastas),
  SecondSeq = SecondFasta#fasta.sequence,

  Scores = analyze( FirstSeq, SecondSeq),
  element(1,Scores) / element(2,Scores).
 
analyze(Seq1,Seq2)->
  analyze_rec(Seq1,Seq2,{0,0}). 

analyze_rec(Seq1,Seq2,Scores)->
  if
    Seq1 == [] -> Scores;
    true ->
      analyze_rec(tl(Seq1),tl(Seq2),score_update(hd(Seq1),hd(Seq2),Scores))
  end.
    
score_update(X,Y,Scores)->
  if
    X == Y -> Scores;
    true ->
      T = is_transition(X,Y),
      case T == true of
	true ->
	  { (element(1,Scores)) + 1 , element(2,Scores) };
	false ->
	  { element(1,Scores) , (element(2,Scores)) + 1 }
      end
  end.

is_transition(X,Y)->
  if 
    X == hd("A") andalso Y == hd("C") -> false;
    X == hd("A") andalso Y == hd("T") -> false;
    X == hd("A") andalso Y == hd("G") -> true;
    
    X == hd("C") andalso Y == hd("A") -> false;
    X == hd("C") andalso Y == hd("T") -> true;
    X == hd("C") andalso Y == hd("G") -> false;

    X == hd("G") andalso Y == hd("A") -> true;
    X == hd("G") andalso Y == hd("C") -> false;
    X == hd("G") andalso Y == hd("T") -> false;

    X == hd("T") andalso Y == hd("A") -> false;
    X == hd("T") andalso Y == hd("C") -> true;
    X == hd("T") andalso Y == hd("G") -> false;

    true -> false
    end.
