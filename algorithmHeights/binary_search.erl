-module(binary_search).

-export([find_indexes/1]).

%%%%% Contract %%%%%
find_indexes(File)->
  {Dict,List} = read_file(File),

  lists:map(
    fun(A) ->
	case dict:is_key(A,Dict) of
	  true ->
	    io:format("~w ",[dict:fetch(A,Dict)]);
	  false ->
	    io:format("-1 ")
	end
    end,List).

%%%%% Internal %%%%%

read_file(File)->
  {ok,Data} = file:read_file(File),

  D = re:replace(Data,"$<<","",[global,{return,list}]),

  DSegments =
    case os:type() of
      {unix,_} ->
	re:split(D,"\n",[{return,list}]);
      _ ->
	re:split(D,"\r\n",[{return,list}])
    end,
  
  StringA = lists:nth(3,DSegments),
  StringB = lists:nth(4,DSegments),

  ListA = 
    [ element(1,string:to_integer(T)) || T <- re:split(StringA," ",[{return,list}]) ],
  ListB = 
    [ element(1,string:to_integer(T)) || T <- re:split(StringB," ",[{return,list}]) ],
  
    {dict:from_list(lists:zip(ListA,lists:seq(1,length(ListA)))),
      ListB}.
