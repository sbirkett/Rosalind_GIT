%% @author birketsc
%% @doc @todo Add description to mortal_rabbits.

-module(mortal_rabbits).

%% ====================================================================
%% API functions
%% ====================================================================
-export([solve/2]).

solve(N,K)->
  rec_iterate(N-1,K,[K-1]).

%% ====================================================================
%% Internal functions
%% ====================================================================

rec_iterate(Months,TTL,Rabbits)->
  io:format("rec_iterator\n",[]),
  io:format("Months = ~w\n",[Months]),
  io:format("TTL = ~w\n",[TTL]),
  io:format("Rabbits = ~w\n",[Rabbits]),
  % Age
  AgedRabbits = [ A - 1 || A <- Rabbits ],
  io:format("AgedRabbits = ~w\n",[AgedRabbits]),
  % Filter and Breed
  SurvivingRabbits =
    lists:foldl( fun ( A, Acc) ->
	  %case A of
	  if
	    A > TTL -> Acc;
	    A == 0 -> Acc;
	    true -> Acc ++ [A,TTL]
	  end
      end,[],AgedRabbits),
  io:format("SR = ~w\n",[SurvivingRabbits]),
  case Months of
    1 -> length( AgedRabbits );
    _ ->
      rec_iterate(Months-1,TTL,SurvivingRabbits)
  end.
