-module(mortal_rabbits).

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/2]).

solve(N,K)->
  rec_iterate3(N,[{K,1}],K).

%% ====================================================================
%% Internal functions
%% ====================================================================

rec_iterate3(1,Rabbits,_)->
	lists:foldl( fun( A, Acc) ->
	  { Key, Vals } = A,
	  Acc + Vals
	end,0,Rabbits);
rec_iterate3(Months,Rabbits,TTL)->
	
  % Breed
  NewRabbits = 
    lists:foldl( fun ( A, Acc ) ->
	  { Key, Vals } = A,
	  if
        Key < TTL ->
		  Acc + Vals;
	    true -> Acc
	  end
	end,0,Rabbits),
  
  % Kill
  ReduceRabbits = 
    lists:foldl( fun (A ,Acc ) ->
	  { Key, Vals } = A,
	  if
	    (Key -1 ) == 0 -> Acc;
		true -> [{Key-1,Vals}|Acc]
	  end
	end,[],Rabbits),
  
  % Recurse 
  rec_iterate3(Months-1,lists:merge([{TTL,NewRabbits}],ReduceRabbits),TTL).