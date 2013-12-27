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
      Rets = find_best_match(hd(Input),tl(Input),Logger),
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

find_best_match(Val,Others,Logger)->
  % make first choice
  %io:format("find_best_match\n",[]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  %First = list_helper:remove_longest_duplication(Val,hd(Others)),
  %io:format("HD Others is list ? = ~w\n",[is_list(hd(Others))]),
  %file:write(Logger,"find_best_match\n"),
  %io:format("First = ~w\n",[First]),
  %Rets = find_best_match_rec(Val,tl(Others),First,hd(Others)),
  Rets = rec_find_match(Val,Others,Val ++ hd(Others),hd(Others)),
  %io:format("Rets = ~w\n",[Rets]),
  %file:write(Logger,hd(Rets)),
  %io:format("hd Rets = ~w\n",[hd(Rets)]),
  %io:write(Logger,"\n"),
  %io:format("Rets = ~w\n",[Rets]),
  %io:format("Bavl is list? = ~w\n",[is_list(lists:last(Rets))]),
  %io:format("Bval in rets? = ~w\n",[lists:member(lists:last(Rets),Others)]),
  lists:delete(lists:last(Rets),Others) ++ [hd(Rets)].

rec_find_match(_,[],Best,BestVal)->
  [Best,BestVal];
rec_find_match(Val,Others,Best,BestVal)->
  %io:format("rec_find_match\n",[]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  %Ret = short_do_match_stuff(Val,hd(Others)),
  Ret = multi_do_match(Val,hd(Others)),
  %Ret = short_do_match_stuff(Val,hd(Others)),
  %io:format("Ret = ~w\n",[Ret]),
  if 
    Ret == [] -> 
      rec_find_match(Val,tl(Others),Best,BestVal);
%    ( ( hd(hd(Ret)) > round ( length(Val) * 0.5 ) ) or
%      ( hd(hd(Ret)) > round ( length(hd(Others)) * 0.5 ))) ->
%      io:format("Found short\n",[]),
%	[hd(Ret),lists:last(Ret)];
    length(hd(Ret)) < length(Best) ->
      rec_find_match(Val,tl(Others),hd(Ret),lists:last(Ret));
    true -> 
      rec_find_match(Val,tl(Others),Best,BestVal)
  end.

short_do_match_stuff(Val,Other)->
  %io:format("short_do_match_stuff\n",[]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Other = ~w\n",[Other]),
  {Overlap,FB} = list_helper:remove_longest_duplication(Val,Other),
  {SOverlap,BF} = list_helper:remove_longest_duplication(Other,Val),
  %io:format("Overlap = ~w\n",[Overlap]),
  %io:format("FB = ~w\n",[FB]),
  %io:format("SOverla = ~w\n",[SOverlap]),
  if
    Overlap > SOverlap ->
      [FB,Overlap,Other];
    true->
      [BF,SOverlap,Other]
  end.

multi_do_match(Val,Other)->
  Pid = spawn(genome_assembler,worker,[]),
  Pid ! {Other,Val,self()},
  {Overlap,FB} = list_helper:remove_longest_duplication(Val,Other),
  receive
    {SOverlap,BF}->
      if
	Overlap > SOverlap ->
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

do_match_stuff( Val, Other) -> 
  %io:format("do_match_stuff\n",[]),
  %io:format("Val = ~s\n",[Val]),
  %io:format("Other = ~s\n",[Other]),
  {Overlap,FB} = list_helper:remove_longest_duplication(Val,Other),
  if
    ( length(Val) > length(Other) ) 
    and ( Overlap > round( ( length(Other) / 2 ) ) ) ->
      [FB,Other];
    ( length(Val) < length(Other) ) 
    and ( Overlap > round ( ( length(Val) / 2)))->
      [FB,Other];
    true ->
      {SecondOverlap,BF} = list_helper:remove_longest_duplication(Other,Val),
      if
	( length(Val) > length(Other) )
	and ( SecondOverlap > round ( ( length(Other) / 2 ))) ->
	  [BF,Other];
	( length(Val) < length(Other) )
	and ( SecondOverlap > round (( length(Val) / 2 ))) ->
	  [BF,Other];
	true -> 
	  if
	    Overlap > SecondOverlap ->
	      [FB,Other];
	    true ->
	      [BF,Other]
	  end
      end
  end.


find_best_match_rec(_,[],Best,BVal)->
  %io:format("best_match_rec base\n",[]),
  %io:format("Best = ~w\n",[Best]),
  %io:format("BVal = ~w\n",[BVal]),
  if
    is_list(Best) == false ->
      io:format("Best not list \n",[]),
      [];
    is_list(BVal) == false ->
      io:format("BVal not list\n",[]),
      [];
    true ->
      [Best,BVal]
  end;

     

find_best_match_rec(Val,Others,Best,BVal)->
  %io:format("best_match_rec\n",[]),
  %io:format("Val = ~w\n",[Val]),
  %io:format("Others = ~w\n",[Others]),
  %io:format("Best = ~w\n",[Best]),
  %io:format("BVal = ~w\n",[BVal]),
  if
    is_list(Best) == false ->
      io:format("Best was not a list !!!\n",[]),
      [];
    is_list(Val) == false ->
      io:format("VAL IS NOT LIST !!!\n",[]);
    is_list(hd(Others)) == false ->
      FB = list_helper:remove_longest_duplication(Val,Others),
      %io:format("FB = ~w\n",[FB]),
      %io:format("Val = ~w\n",[Val]),
      %io:format("Others = ~w\n",[Others]),
      BF = list_helper:remove_longest_duplication(Others,Val),
      %io:format("BF = ~w\n",[BF]),
      if
	FB == 0 ->
	  io:format("FB Was 0 \n",[]),
	  [];
	BF == 0 ->
	  io:format("BF was 0 \n",[]),
	  [];
	length(FB) < length(BF) ->
	  if
	    length(Best) > length(FB) ->
	      find_best_match_rec(Val,[],FB,Others);
	    true-> find_best_match_rec(Val,[],Best,BVal)
	  end;

	true->
	  if
	    length(Best) > length(BF) ->
	  	find_best_match_rec(Val,[],FB,Others);
	    true ->
	      find_best_match_rec(Val,[],Best,BVal)
	  end
      end;
    true -> 
      FB = list_helper:remove_longest_duplication(Val,hd(Others)),
      BF = list_helper:remove_longest_duplication(hd(Others),Val),
      %io:format("Length FB = ~w\n",[length(FB)]),
      %io:format("Length BF = ~w\n",[length(BF)]),
      %io:format("Length Val ~w\n",[length(Val)]),
      %io:format("length of hd other = ~w\n",[length(hd(Others))]),
      if
	FB == 0 ->
	  %io:format("FB was 0\n",[]),
	  %io:format("Val = ~w\n",[Val]),
	  %io:format("hd others = ~w\n",[hd(Others)]),
	  [];
	BF == 0 -> 
	  io:format("BF was 0\n",[]),
	  io:format("Val = ~w\n",[Val]),
	  io:format("hd others = ~w\n",[hd(Others)]),
	  [];
	( length(FB) - length(Val) ) < ( round ( length ( Val ) / 2) ) ->
	  %io:format("Shorint FB \n",[]),
	  find_best_match_rec(Val,[],FB,hd(Others));
	( length(BF) - length(Val) ) < ( round ( length ( Val  ) /2 ) ) ->
	  %io:format("Shorint BF \n",[]),
	  find_best_match_rec(Val,[],BF,hd(Others));
	%length(FB) < (round(length(Val)/2) + 1) ->
	 % io:format("Shorting FB \n",[]),
	  %find_best_match_rec(Val,[],FB,hd(Others));
	%length(BF) < (round(length(Val)/2) + 1) ->
	 % io:format("Shorting BF\n",[]),
	  %afind_best_match_rec(Val,[],BF,hd(Others));
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
       end
 end.
