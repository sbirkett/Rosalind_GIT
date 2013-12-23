-module(genome_assembler).

-export([assemble/1]).

-include_lib("../rosalind_records.hrl").

-import(list_helper,[remove_longest_duplication/2]).
-import(fasta_reader,[read/1]).

assemble(N)->
  compile:file("../fasta_reader.erl"),
  compile:file("list_helper.erl"),
  Fastas = [ T#fasta.sequence || T <- fasta_reader:read(N)],
  process_all(Fastas).

process_all(N)->
  process_all_rec(N).

process_all_rec(Input)->
  %io:format("process_all_rec\n",[]),
  %io:format("Input = ~w\n",[Input]),
  if
    length(Input) == 1 -> Input;
    true -> 
      Rets = perform_iteration(Input),
      %io:format("Rets = ~w\n",[Rets]),
      process_all_rec(Rets)
  end.

perform_iteration(Input)->
  perform_iteration_rec(Input,[]).

perform_iteration_rec(Input,Outs)->
  %io:format("perform_iteration_rec\n",[]),
  %io:format("Input = ~w\n",[Input]),
  %io:format("Outs = ~w\n",[Outs]),
  if
    Input == [] -> Outs;
    length(Input) == 1 -> Outs ++ Input;
    true ->
      Rets = find_best_match(hd(Input),tl(Input)), 
      %io:format("Rets = ~w\n",[Rets]),
      perform_iteration_rec(lists:last(Rets),Outs ++ [hd(Rets)])
  end.

find_best_match(Val,Others)->
  % make first choice
  %io:format("find_best_match\n",[]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  First = list_helper:remove_longest_duplication(Val,hd(Others)),
  Rets = find_best_match_rec(Val,tl(Others),First,hd(Others)),
  %io:format("Rets = ~w\n",[Rets]),
  [hd(Rets),lists:delete(lists:last(Rets),Others)].

find_best_match_rec(_,[],Best,BVal)->[Best,BVal];
find_best_match_rec(Val,Others,Best,BVal)->
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  %io:format("Best = ~w\n",[Best]),
  %io:format("CurIndex = ~w\n",[CurIndex]),
  %io:format("BVal = ~w\n",[BVal]),
  FB = list_helper:remove_longest_duplication(Val,hd(Others)),
  BF = list_helper:remove_longest_duplication(hd(Others),Val),
  if
    length(FB) < length(BF) ->
	if
	  length(Best) > length(FB) -> find_best_match_rec(Val,tl(Others),FB,hd(Others));
	  true-> find_best_match_rec(Val,tl(Others),Best,BVal)
	end;
     true->
       if
	 length(Best) > length(BF) -> find_best_match_rec(Val,tl(Others),FB,hd(Others));
	 true -> find_best_match_rec(Val,tl(Others),Best,BVal)
       end
  end.
