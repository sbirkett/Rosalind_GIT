%% @author birketsc
%% @doc @todo Add description to fibonacci.


-module(fibonacci).

%% ====================================================================
%% API functions
%% ====================================================================
-export([fib/1]).

fib(Num)->
	fibs(Num,2,0,1).

%% ====================================================================
%% Internal functions
%% ====================================================================

fibs(Targ,Index,A,B)->
	case Targ == Index of
		true -> A+B;
		false -> fibs(Targ,Index+1,B,A+B)
	end.
		