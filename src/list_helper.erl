-module(list_helper).

%% ====================================================================
%% API functions
%% ====================================================================
-export([swap_elements/3]).

swap_elements(List,X,Y)->
  swap_elements_rec(List,X,Y,[],1).

%% ====================================================================
%% Internal functions
%% ====================================================================

swap_elements_rec(List,X,Y,Out,CurrIndex)->
  if
	  (CurrIndex -1 ) == length(List) -> Out;
	  CurrIndex == X -> swap_elements_rec(List,X,Y,Out ++ [lists:nth(Y,List)],CurrIndex+1);
	  CurrIndex == Y -> swap_elements_rec(List,X,Y,Out ++ [lists:nth(X,List)],CurrIndex+1);
	  true ->
		  swap_elements_rec(List,X,Y,Out ++ [lists:nth(CurrIndex,List)],CurrIndex+1)
  end.