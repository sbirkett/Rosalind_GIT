%% @author birketsc
%% @doc @todo Add description to max_matching.

-module(max_matching).

-include_lib("../rosalind_records.hrl").
-import(fasta_reader,[read/1]).

% A = 65
% C = 67
% G = 71
% U = 85

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/1,factorial/1]).

solve(File)->
	compile:file("../fasta_reader.erl"),
	Fasta = hd(fasta_reader:read(File)),
	Seq = Fasta#fasta.sequence,
    CharDict = char_counts(Seq,dict:new()),
	ACount = dict:fetch(65, CharDict),
	CCount = dict:fetch(67, CharDict),
	GCount = dict:fetch(71, CharDict),
	UCount = dict:fetch(85, CharDict),
	io:format("~w\n",[[ACount,UCount,CCount,GCount]]),
	X = 
		case ( ACount > UCount ) of
			true -> lists:foldl( fun (A, Acc) ->
										 Acc * A end , 1, lists:seq(ACount-UCount+1,ACount));
			false -> lists:foldl( fun (A , Acc) ->
										   Acc * A end, 1, lists:seq(UCount-ACount+1,UCount))
		end,
	Y =
		case ( GCount > CCount ) of 
			true ->  lists:foldl( fun (A , Acc )->
										   Acc * A end , 1, lists:seq(GCount-CCount+1,GCount));
			false -> lists:foldl( fun ( A, Acc) ->
										   Acc * A end , 1, lists:seq(CCount -GCount+1,CCount))
		end,
	
    X * Y.
%% ====================================================================
%% Internal functions
%% ====================================================================

factorial(0)->1;
factorial(N) -> N * factorial(N-1).
	
char_counts([],Outs)->Outs;
char_counts([Char|Seq],Outs)->
	char_counts(Seq,dict:update(Char, fun(A) -> A + 1 end, 1, Outs)).