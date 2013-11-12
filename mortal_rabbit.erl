-module(mortal_rabbit).

-export([start/1]).

-record(rabbit,{ttl}).
-record(environ,{adults,children}).

start(Input)->
  Vals = string:tokens(Input," "),
  K = list_to_integer(lists:last(Vals)),
  N = list_to_integer(hd(Vals)),
  
  Fem = #rabbit{ ttl = K},
  %Final = breed(#environ{ adults = [], children = 1 } , N, K),
  Final = breed(#environ{ adults = [Fem],children = 0 },N,K),
  length(Final#environ.adults).
  
breed(E,N,K)->
  
  io:format("E = ~w\n",[E]),
  %io:format("N = ~w\n",[N]),
  if
    N == 1 -> E;
    true->
      %io:format("Last Gen = ~w\n",[E#environ.adults]),
      Living = clean_dead(E),
      %io:format("Living = ~w\n",[Living]),
      All_Adults = lists:append(Living, make_rabbits(E#environ.children,[],K)),
      %io:format("All_Adults ~w\n",[All_Adults]),
      NewChildren = length( [ Z || Z <- All_Adults, 
	  Z#rabbit.ttl <3 ] ),
      %io:format("NewChildren ~w\n",[NewChildren]),
      breed(#environ{ adults = All_Adults, children = NewChildren },N-1,K)
  end.

make_rabbits(Count,Out,Ttl)->
  if
    Count == 0 -> Out;
    true -> make_rabbits(Count-1,  [ #rabbit{ttl = Ttl} | Out] , Ttl)
  end.

clean_dead(E)->
    lists:foldl( fun ( Var, Acc) ->
	  if
	    Var#rabbit.ttl > 1 ->
	      [#rabbit{ttl = Var#rabbit.ttl -1}|Acc];
	      true -> Acc
	    end
	end, [], E#environ.adults).
