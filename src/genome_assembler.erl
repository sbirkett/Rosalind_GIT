-module(genome_assembler).

-export([assemble/1,worker/0]).

-include_lib("../rosalind_records.hrl").

-import(list_helper,[remove_longest_duplication/2]).
-import(fasta_reader,[read/1]).

assemble(N)->
  compile:file("../fasta_reader.erl"),
  compile:file("list_helper.erl"),
  Fastas = [ T#fasta.sequence || T <- fasta_reader:read(N)],
  {ok,Logger} =file:open("output.txt",[write]),
  process_all(Fastas,Logger).

process_all(N,Logger)->
  process_all_rec(N,Logger).

process_all_rec(Input,Logger)->
  %io:format("process_all_rec\n",[]),
  %io:format("Input = ~w\n",[Input]),
  %file:write(Logger,"process_all_rec\n"),
  %file:write(Logger,"input length = "),
  %io:write(Logger,length(Input)),
  io:format("Remaning = ~w\n",[length(Input)]),
  %file:write(Logger,"\n"),
  %file:write(Logger,Input),
  if
    length(Input) == 1 -> Input;
    true ->
      Rets = find_best_match(hd(Input),tl(Input),Logger,[]),
      if 
	length(Rets) == length(Input) ->
	  file:write(Logger,"Something terrible happened\n"),
	  %io:write(Logger,Input),
	  %io:write(Logger,Rets),
	  [];
	true->
      		%file:write(Logger,Rets),
      		process_all_rec(Rets,Logger)
      end
      %Rets = perform_iteration(Input),
      %io:format("Rets = ~w\n",[Rets]),
      %process_all_rec(Rets)
  end.

find_best_match(Val,Others,Logger,CarryOver)->
  % make first choice
  %io:format("find_best_match\n",[]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  Rets = rec_find_match(Val,Others,Val ++ hd(Others),hd(Others),0),
  Overlap = hd(tl(Rets)),
  %io:format("Overlap = ~w\n",[Overlap]),
  %io:format("Required = ~w\n",[round(length(Val)/2)]),
  if
    ( round ( length(Val) / 2 ) > Overlap ) ->
      %io:format("Overlap too short\n",[]),

      find_best_match(hd(Others),tl(Others),Logger,CarryOver ++ [Val]);
    true ->
      lists:merge(lists:delete(lists:last(Rets),Others) ++ [hd(Rets)],CarryOver)
  end.

rec_find_match(_,[],Best,BestVal,BestOverlap)->
  [Best,BestOverlap,BestVal];
rec_find_match(Val,Others,Best,BestVal,BestOverlap)->
  %io:format("rec_find_match\n",[]),
  %io:format("BestOverlap = ~w\n",[BestOverlap]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  Ret = multi_do_match(Val,hd(Others)),
  %io:format("Ret = ~w\n",[Ret]),
  %io:format("Length hd of Ret = ~w\n",[length(hd(Ret))]),
  %io:format("Letnght of best = ~w\n",[length(Best)]),
  Overlap = hd(tl(Ret)),
  %io:format("in rec-F_m Overlap = ~w\n",[Overlap]),
  if 
    Ret == [] -> 
      io:format("Ret was empty list !!!\n",[]),
      rec_find_match(Val,tl(Others),Best,BestVal,BestOverlap);
%    ( ( hd(hd(Ret)) > round ( length(Val) * 0.5 ) ) or
%      ( hd(hd(Ret)) > round ( length(hd(Others)) * 0.5 ))) ->
%      io:format("Found short\n",[]),
%	[hd(Ret),lists:last(Ret)];
    %length(hd(Ret)) < length(Best) ->
    Overlap > BestOverlap ->
      rec_find_match(Val,tl(Others),hd(Ret),lists:last(Ret),hd(tl(Ret)));
    true -> 
      rec_find_match(Val,tl(Others),Best,BestVal,BestOverlap)
  end.

multi_do_match(Val,Other)->
  Pid = spawn(genome_assembler,worker,[]),
  Pid ! {Other,Val,self()},
  {Overlap,FB} = list_helper:remove_longest_duplication(Val,Other),
  %io:format("Overlap = ~w\n",[Overlap]),
  %io:format("FB = ~w\n",[FB]),
  receive
    {SOverlap,BF}->
      %io:format("SOverlap = ~w\n",[SOverlap]),
      %io:format("Overlap = ~w\n",[Overlap]),
      %io:format("BF = ~w\n",[BF]),
      if
	Overlap > SOverlap ->
	  [FB,Overlap,Other];
	Overlap == SOverlap ->
	  %io:format("Equality found !!!\n",[]),
	  [FB,Overlap,Other];
	true ->
	  [BF,SOverlap,Other]
      end
  end.

worker()->
  receive
    %{Val,Other,Sender_PID}->
    {Val,Other,Sender_PID} ->
      %io:format("Val = ~w\n",[Val]),
      %io:format("Other = ~w\n",[Other]),
      Sender_PID ! list_helper:remove_longest_duplication(Val,Other)
  end.
