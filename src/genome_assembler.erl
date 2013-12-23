-module(genome_assembler).

-export([assemble/1]).

-include_lib("../rosalind_records.hrl").

-import(list_helper,[remove_duplication/1]).
-import(fasta_reader,[read/1]).

assemble(N)->
  compile:file("../fasta_reader.erl"),
  compile:file("list_helper.erl"),
  Fastas = [ T#fasta.sequence || T <- fasta_reader:read(N)],
  process_all(Fastas).

process_all(N)->
  process_all_rec(N).

process_all_rec(Input)->
  if
    length(Input) == 1 -> Input;
    true -> process_all_rec(perform_iteration(Input))
  end.

perform_iteration(Input)->
  perform_iteration_rec(Input,[]).

perform_iteration_rec(Input,Outs)->
  if
    Input == [] -> Outs;
    length(Input) == 1 -> Outs ++ Input;
    true ->
      Rets = find_best_match(hd(Input),tl(Input)), 
      perform_iteration_rec(hd(Rets),Outs ++ [tl(Rets)])
  end.

find_best_match(Val,Others)->
  % make first choice
  First = 1,
  find_best_match_rec(Val,Others,First).

find_best_match_rec(Val,Others,Best)->
  FB = list_helper:remove_duplication([Val] ++ [hd(Others)]),
  BF = list_helper:remove_duplication([Val] ++ [hd(Others)]),
  1.

