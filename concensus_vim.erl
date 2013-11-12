-module(concensus_vim).
-export([start/1]).
-import(fasta_reader,[read/1]).
-compile(fasta_reader).

-include_lib("rosalind_records.hrl").

start(N)->
  Fastas = [ K#fasta.sequence || K <- fasta_reader:read(N)],
  K = iter_pos(Fastas,[]),
  lists:foldl( fun ( X , Acc ) ->
	print_char(X)
	end,
       [],K).

print_char(X)->
  %io:format("X = ~w\n",[X]),
  Max = lists:max(X),
  First = lists:nth(1,X),
  Second = lists:nth(2,X),
  Third = lists:nth(3,X),
  Fourth = lists:nth(4,X),
  if
    Max == First -> io:format("A",[]);
    Max == Second -> io:format("C",[]);
    Max == Third -> io:format("G",[]);
    true -> io:format("T",[])
  end.
   
iter_pos(N,X)->
  %io:format("N = ~w\n",[N]),
  %io:format("X = ~w\n",[X]),
  T = hd(N),
  if
    T == [] -> X;
    true -> 
      H = hd(N),
      
      if
	is_list(H) -> iter_pos( [ tl(Z) || Z <- N ] ,X++ [count_vals( [ hd(U) || U <- N ] , [0,0,0,0])]);
	true -> iter_pos([],X ++ [count_vals( [ U || U <- N ] , [0,0,0,0])])
      end
  end.

count_vals(N,X)->
  %io:format("X = ~w\n",[X]),
  if
    N == [] -> X;
    true ->
      H = hd(N),
      %io:format("H = ~w\n",[H]),
      %io:format("List lasts= ~w\n",[lists:last(X)]),
      if
	H == 65 -> count_vals(tl(N),[hd(X) + 1,lists:nth(2,X),lists:nth(3,X),lists:nth(4,X)]);
	H == 67 -> count_vals(tl(N),[hd(X),lists:nth(2,X)+1,lists:nth(3,X),lists:nth(4,X)]);
	H == 71 -> count_vals(tl(N),[hd(X),hd(tl(X)),lists:nth(3,X) +1,lists:nth(4,X)]);
	true -> count_vals(tl(N),[hd(X), hd(tl(X)),lists:nth(3,X),lists:last(X)+1])
      end
  end.

